import 'package:flutter/material.dart';
import 'package:navigation2/stolen_demo/router/pages/home_page.dart';
import 'package:navigation2/v1-attempt-bad/screens/screens.dart';
import 'paths.dart';

class CustomAppState extends ChangeNotifier {
  int _selectedIndex;

  // Maybe add the offers db query here?

  CustomAppState() : _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int idx) {
    _selectedIndex = idx;
    notifyListeners();
  }

  // get selectedBook => _selectedBook;

  // set selectedBook(Book? book) {
  //   _selectedBook = book;
  //   notifyListeners();
  // }

  // int? getSelectedBookById() {
  //   if (_selectedBook == null || !books.contains(_selectedBook)) return null;
  //   return books.indexOf(_selectedBook!);
  // }

  // void setSelectedBookById(int id) {
  //   if (id < 0 || id > books.length - 1) {
  //     return;
  //   }

  //   _selectedBook = books[id];
  //   notifyListeners();
  // }
}

class CustomRouteInformationParser
    extends RouteInformationParser<CustomRoutePath> {
  @override
  Future<CustomRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');

    switch (uri.pathSegments.first) {
      case "account":
        return AccountPath();

      case "login":
        return LoginPath();

      case "register":
        return RegisterPath();

      case "":
        return HomePath();

      case "offers":
        return OffersPath();

      case "history":
        return HistoryPath();

      default:
        return LoginPath();
    }
  }

  @override
  RouteInformation restoreRouteInformation(CustomRoutePath configuration) {
    if (configuration is HomePath) {
      return const RouteInformation(location: '/');
    }
    if (configuration is AccountPath) {
      return const RouteInformation(location: '/account');
    }
    if (configuration is LoginPath) {
      return const RouteInformation(location: '/login');
    }
    if (configuration is RegisterPath) {
      return const RouteInformation(location: '/register');
    }
    if (configuration is OffersPath) {
      return const RouteInformation(location: '/offers');
    }
    if (configuration is HistoryPath) {
      return const RouteInformation(location: '/history');
    }

    return const RouteInformation();
  }
}

class CustomRouterDelegate extends RouterDelegate<CustomRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CustomRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  CustomAppState appState = CustomAppState();

  CustomRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
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
        MaterialPage(
          child: AppShell(appState: appState),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // if (appState.selectedBook != null) {
        //   appState.selectedBook = null;
        // }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(CustomRoutePath configuration) async {
    var path = configuration;
    if (path is HomePath) {
      appState.selectedIndex = 0;
    } else if (path is OffersPath) {
      appState.selectedIndex = 1;
    } else if (path is AccountPath) {
      appState.selectedIndex = 4;
    }
  }
}

// Widget that contains the AdaptiveNavigationScaffold
class AppShell extends StatefulWidget {
  final CustomAppState appState;

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
        currentIndex: appState.selectedIndex,
        onTap: (newIndex) {
          appState.selectedIndex = newIndex;
        },
      ),
    );
  }
}

class InnerRouterDelegate extends RouterDelegate<CustomRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CustomRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  CustomAppState _appState;
  CustomAppState get appState => _appState;

  set appState(CustomAppState value) {
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
        if (appState.selectedIndex == 0)
            ...[
              const FadeAnimationPage(
                child: RequestScreen(),
                key: ValueKey('RequestsScreen'),
              ),
            ]
        else
          const FadeAnimationPage(
            child: AccountScreen(),
            key: ValueKey('AccountScreen'),
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
