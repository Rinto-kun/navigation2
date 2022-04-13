// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:navigation2/v1-attempt-bad/navigation/paths.dart';

class Paths {
  static const String splash = "/";
  static const String home = "/home";
  static const String offers = "/offers";
  static const String history = "/history";
  static const String account = "/account";
  static const String login = "/login";
  static const String register = "/register";
}

class CustomRouteInformationParser
    extends RouteInformationParser<CustomRoutePath> {
  @override
  Future<CustomRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');

    if (uri.pathSegments.isEmpty) {
      return LoginPath();
    }

    switch (uri.pathSegments.first) {
      case Paths.home:
        return HomePath();

      case Paths.offers:
        return OffersPath();

      case Paths.history:
        return HistoryPath();

      case Paths.account:
        return AccountPath();

      case Paths.register:
        return RegisterPath();

      case "":
      case Paths.login:
      default:
        return LoginPath();
    }
  }

  @override
  RouteInformation restoreRouteInformation(CustomRoutePath configuration) {
    if (configuration is HomePath) {
      return const RouteInformation(location: Paths.home);
    }
    if (configuration is AccountPath) {
      return const RouteInformation(location: Paths.account);
    }
    if (configuration is LoginPath) {
      return const RouteInformation(location: Paths.login);
    }
    if (configuration is RegisterPath) {
      return const RouteInformation(location: Paths.register);
    }
    if (configuration is OffersPath) {
      return const RouteInformation(location: Paths.offers);
    }
    if (configuration is HistoryPath) {
      return const RouteInformation(location: Paths.history);
    }

    return const RouteInformation();
  }
}
