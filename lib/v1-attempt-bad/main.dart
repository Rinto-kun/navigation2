import 'package:flutter/material.dart';
import 'package:navigation2/v1-attempt-bad/nav.dart';

void main() {
  runApp(const MyApp());
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CustomRouterDelegate _routerDelegate = CustomRouterDelegate();
  final CustomRouteInformationParser _routeInformationParser = CustomRouteInformationParser();

  bool onPopPage(Route<dynamic> route, dynamic result) {
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
        title: "Navigation",
        routeInformationParser: _routeInformationParser,
        routerDelegate: _routerDelegate);
  }
}
