import 'package:flutter/material.dart';
import '../constants/paths.dart';
import 'app_state.dart';

class CustomRouteInformationParser extends RouteInformationParser<AppState> {
  @override
  Future<AppState> parseRouteInformation(
      RouteInformation routeInformation) async {
    print("In parseRouteInformation " + routeInformation.location.toString());
    final uri = Uri.parse(routeInformation.location ?? '');

    if (uri.pathSegments.isEmpty) {
      return AppState();
    }

    switch (uri.pathSegments.first) {
      case Paths.home:
        return AppState.home();

      case Paths.offers:
        return AppState.offers();

      case Paths.history:
        return AppState.history();

      case Paths.account:
        return AppState.account();

      case Paths.register:
        return AppState.login();

      case "":
      case Paths.login:
      default:
        return AppState.login();
    }
  }

  @override
  RouteInformation restoreRouteInformation(AppState configuration) {
    print("In configuration" + configuration.toString());
    if (configuration.isHome()) {
      return const RouteInformation(location: Paths.home);
    }
    if (configuration.isAccountScreen()) {
      return const RouteInformation(location: Paths.account);
    }
    if (configuration.isLogin()) {
      return const RouteInformation(location: Paths.login);
    }
    if (configuration.isLogin()) {
      // change to register
      return const RouteInformation(location: Paths.login);
    }
    if (configuration.isOffersScreen()) {
      return const RouteInformation(location: Paths.offers);
    }
    if (configuration.isHistoryScreen()) {
      return const RouteInformation(location: Paths.history);
    }
    return const RouteInformation();
  }
}
