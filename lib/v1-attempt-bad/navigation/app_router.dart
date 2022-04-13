
import 'package:flutter/material.dart';
import '../models/offer.dart';
import '../screens/splash_screen.dart';
import 'paths.dart';
import '../screens/screens.dart';
import 'app_state.dart';

class AppRouter extends RouterDelegate<CustomRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CustomRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AppState appState;

  AppRouter(this.appState) : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appState.removeListener(notifyListeners);

    super.dispose();
  }

  // @override
  // BookRoutePath get currentConfiguration {
  //   if (appState.selectedIndex == 1) {
  //     return BooksSettingsPath();
  //   } else {
  //     if (appState.selectedBook == null) {
  //       return BooksListPath();
  //     } else {
  //       return BooksDetailsPath(appState.getSelectedBookById());
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        /// Show the splash screen when the app isn't initialized.
        if(!appState.isInitialized) SplashScreen.page()

        else if(!appState.loginStatus) LoginScreen(onLogin: appState.logout).page()
        
        else MaterialPage(
          child: AppShell(appState: appState),
        ),
      ],
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    // 5
    // TODO: Handle Onboarding and splash
    // TODO: Handle state when user closes grocery item screen
    // TODO: Handle state when user closes profile screen
    // TODO: Handle state when user closes WebView screen

    notifyListeners();
    return true;
  }

  @override
  Future<void> setNewRoutePath(CustomRoutePath configuration) async {
    var path = configuration;
    if (path is HomePath) {
      appState.selectedTab = 0;
    } else if (path is OffersPath) {
      appState.selectedTab = 1;
    } else if (path is RequestsPath) {
      appState.selectedTab = 0;
    } else if (path is HistoryPath) {
      appState.selectedTab = 2;
    } else if (path is AccountPath) {
      appState.selectedTab = 3;
    } else if (path is LoginPath) {
      appState.selectedTab = 4;
    } else {
      appState.selectedTab = 999;
    }
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
    super.initState();
    _routerDelegate = InnerRouterDelegate(widget.appState);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
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
    var appState = widget.appState;

    // Claim priority, If there are parallel sub router, you will need
    // to pick which one should take priority;
    _backButtonDispatcher.takePriority();

    return Scaffold(
      appBar: AppBar(),
      body: Router(
        routerDelegate: _routerDelegate,
        // backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar:
          (appState.selectedTab >= 0 && appState.selectedTab < 4)
              ? BottomNavigationBar(
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  // backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.handyman_outlined), label: "Offers"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.history), label: "History"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline), label: 'Account'),
                  ],
                  currentIndex: appState.selectedTab,
                  onTap: (newIndex) {
                    appState.selectedTab = newIndex;
                  },
                )
              : null,
    );
  }
}

class InnerRouterDelegate extends RouterDelegate<CustomRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CustomRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppState _appState;
  AppState get appState => _appState;

  set appState(AppState value) {
    if (value == _appState) {
      return;
    }
    _appState = value;
    notifyListeners();
  }

  InnerRouterDelegate(this._appState);

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

        ] else if (appState.selectedTab == 4) ...[
          FadeAnimationPage(
              key: const ValueKey("LoginScreen"),
              child: LoginScreen(onLogin: () {
                appState.selectedTab = 0;
              }))
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
  Future<void> setNewRoutePath(CustomRoutePath configuration) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }

  // void _handleBookTapped(Book book) {
  //   appState.selectedBook = book;
  //   notifyListeners();
  // }
}

class FadeAnimationPage extends Page {
  final Widget child;

  const FadeAnimationPage({required LocalKey key, required this.child})
      : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}
