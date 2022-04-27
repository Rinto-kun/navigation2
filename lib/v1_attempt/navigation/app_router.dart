import 'package:flutter/material.dart';
import 'route_information_parser.dart';
import '../models/offer.dart';
import '../screens/login_screen.dart';
import '../screens/splash_screen.dart';
import 'fade_animation.dart';
import '../screens/screens.dart';
import 'app_state.dart';

class AppRouter extends RouterDelegate<AppState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  late AppState appState;

  AppRouter(this.appState) : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appState.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        /// Show the splash screen when the app isn't initialized.
        if (!appState.isInitialized)
          SplashScreen.page()
        else if (!appState.loggedIn)
          LoginScreen(
                  onLoginUser: appState.loginUser,
                  onLoginEmployee: appState.loginEmployee)
              .page()
        else
          MaterialPage(
            child: AppShell(appState: this.appState),
          ),
      ],
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    // TODO: Handle state when user closes grocery item screen
    // TODO: Handle state when user closes profile screen

    notifyListeners();
    return true;
  }

  @override
  Future<void> setNewRoutePath(AppState path) async {
    print("Set new route path " + path.toString());
    if (path.isHome()) {
      appState.selectedTab = 0;
    } else if (path.isOffersScreen()) {
      appState.selectedTab = 1;
    } else if (path.isHistoryScreen()) {
      appState.selectedTab = 2;
    } else if (path.isAccountScreen()) {
      appState.selectedTab = 3;
    } else if (path.isSplash()) {
      appState.isInitialized = false;
    } else if (path.isLogin()) {
      appState.loggedIn = false;
      appState.isInitialized = true;
    } else {
      appState.isUnknown = true;
    }
    notifyListeners();
  }
}

// Widget that contains the AdaptiveNavigationScaffold
class AppShell extends StatefulWidget {
  final AppState appState;

  const AppShell({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late InnerRouterDelegate _routerDelegate;
  late ChildBackButtonDispatcher _backButtonDispatcher;

  @override
  void initState() {
    print("init appshell");
    super.initState();
    _routerDelegate = InnerRouterDelegate(widget.appState);
  }

  @override
  void didUpdateWidget(AppShell oldWidget) {
    print("did update");
    super.didUpdateWidget(oldWidget);
    _routerDelegate.appState = widget.appState;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher!
        .createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    // Claim priority, If there are parallel sub router, you will need
    // to pick which one should take priority;
    _backButtonDispatcher.takePriority();

    return Scaffold(
      appBar: AppBar(),
      body: Router(
        routerDelegate: _routerDelegate,
        // routeInformationParser: CustomRouteInformationParser(),
        backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Color.fromARGB(255, 0, 0, 0),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.handyman_outlined), label: "Offers"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Account'),
        ],
        currentIndex: widget.appState.selectedTab,
        onTap: _handleItemTapped,
      ),
    );
  }

  void _handleItemTapped(int newIndex) {
    widget.appState.selectedTab = newIndex;
  }
}

class InnerRouterDelegate extends RouterDelegate<AppState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  late AppState _appState;
  AppState get appState => _appState;
  set appState(AppState value) {
    if (value == _appState) {
      return;
    }
    _appState = value;
    notifyListeners();
  }

  InnerRouterDelegate(this._appState)
      : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // ...[] Extends the list
        if (appState.selectedTab == 0) ...[
          const FadeAnimationPage(
              key: ValueKey("RequestScreen"), child: RequestsScreen()),

          if (appState.offerId != null)
            FadeAnimationPage(
                key: ValueKey("OfferDetails${appState.offerId}"),
                child: OfferDetailsScreen(data: OfferDetails.demo()))

          // Here list the stack of particular screens like the details for an offer, etc.
        ] else if (appState.selectedTab == 1) ...[
          const FadeAnimationPage(
              key: ValueKey("OffersScreen"), child: OffersScreen()),
        ] else if (appState.selectedTab == 2) ...[
          const FadeAnimationPage(
              key: ValueKey("HistoryScreen"), child: HistoryScreen()),
          if (appState.offerId != null)
            FadeAnimationPage(
                key: ValueKey("OfferDetails${appState.offerId}"),
                child: OfferDetailsScreen(data: OfferDetails.demo()))
        ] else if (appState.selectedTab == 3) ...[
          const FadeAnimationPage(
              key: ValueKey("AccountScreen"), child: AccountScreen()),
          if (appState.offerId != null)
            FadeAnimationPage(
                key: ValueKey("OfferDetails${appState.offerId}"),
                child: OfferDetailsScreen(data: OfferDetails.demo()))
        ] else
          const FadeAnimationPage(
            child: Error404Screen(),
            key: ValueKey('Error404Screen'),
          ),
      ],
      onPopPage: (route, result) {
        // appState.selectedBook = null;
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppState configuration) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }
}
