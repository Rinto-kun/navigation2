import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'navigation/app_state.dart';
import 'navigation/route_information_parser.dart';
import 'package:url_strategy/url_strategy.dart';

import 'navigation/app_router.dart';

void main() {
  /// Removes the # from the web URL.
  if(kIsWeb) setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Contains the state of the application.
  final AppState _appState = AppState();

  /// Manages the central navigation
  late AppRouter _routerDelegate;

  /// Responsible for interpreting the route information and restoring it from state.
  final CustomRouteInformationParser _routeInformationParser =
      CustomRouteInformationParser();

  @override
  void initState() {
    _routerDelegate = AppRouter(_appState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
    MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
      backButtonDispatcher: RootBackButtonDispatcher(),);
  }
}
