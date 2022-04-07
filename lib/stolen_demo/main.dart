import 'package:common/cache/preference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigation2/stolen_demo/router/my_app_router_delegate.dart';
import 'package:navigation2/stolen_demo/data/auth_repository.dart';
import 'package:navigation2/stolen_demo/data/colors_repository.dart';
import 'package:navigation2/stolen_demo/viewmodels/auth_view_model.dart';
import 'package:navigation2/stolen_demo/viewmodels/colors_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'router/my_app_route_information_parser.dart';


void main() {
  // Sets the URL for working with browsers.
  if(kIsWeb) setUrlStrategy(PathUrlStrategy());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyAppRouterDelegate delegate;
  late MyAppRouteInformationParser parser;
  late AuthRepository authRepository;
  late ColorsRepository colorsRepository;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository(Preference());
    colorsRepository = ColorsRepository();
    delegate = MyAppRouterDelegate(authRepository, colorsRepository);
    parser = MyAppRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(authRepository),
        ),
        ChangeNotifierProvider<ColorsViewModel>(
          create: (_) => ColorsViewModel(colorsRepository),
        ),
      ],
      child: MaterialApp.router(
        routerDelegate: delegate,
        routeInformationParser: parser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
