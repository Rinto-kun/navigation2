import 'package:common/extensions/color_extensions.dart';
import 'package:common/model/shape_border_type.dart';
import 'package:flutter/material.dart';
import 'package:navigation2/stolen_demo/router/pages/color_page.dart';
import 'package:navigation2/stolen_demo/router/pages/home_page.dart';
import 'package:navigation2/stolen_demo/router/pages/login_page.dart';
import 'package:navigation2/stolen_demo/router/pages/shape_page.dart';
import 'package:navigation2/stolen_demo/router/pages/splash_page.dart';
import 'package:navigation2/stolen_demo/data/auth_repository.dart';
import 'package:navigation2/stolen_demo/data/colors_repository.dart';

import 'my_app_configuration.dart';
import 'pages/unknown_page.dart';

class MyAppRouterDelegate extends RouterDelegate<MyAppConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyAppConfiguration> {
  
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  
  final AuthRepository authRepository;
  final ColorsRepository colorsRepository;

  bool? _show404;
  bool? get show404 => _show404;
  set show404(bool? value) {
    _show404 = value;
    if (value == true) {
      selectedColorCode = null;
      selectedShapeBorderType = null;
    }
    notifyListeners();
  }

  bool? _loggedIn;
  bool? get loggedIn => _loggedIn;
  set loggedIn(value) {
    if (_loggedIn == true && value == false) {
      // It is a logout!
      _clear();
    }
    _loggedIn = value;
    notifyListeners();
  }

  List<Color>? _colors;
  List<Color>? get colors => _colors;
  set colors(List<Color>? value) {
    _colors = value;
    final selectedColorCode = this.selectedColorCode;
    if (value != null && selectedColorCode != null) {
      show404 = !_isValidColor(value, selectedColorCode);
    }
    notifyListeners();
  }

  String? _selectedColorCode;
  String? get selectedColorCode => _selectedColorCode;
  set selectedColorCode(String? value) {
    final colors = this.colors;
    if (colors != null && value != null) {
      show404 = !_isValidColor(colors, value);
    }
    _selectedColorCode = value;
    notifyListeners();
  }

  ShapeBorderType? _selectedShapeBorderType;
  ShapeBorderType? get selectedShapeBorderType => _selectedShapeBorderType;
  set selectedShapeBorderType(ShapeBorderType? value) {
    _selectedShapeBorderType = value;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  MyAppRouterDelegate(this.authRepository, this.colorsRepository) {
    _init();
  }

  _init() async {
    loggedIn = await authRepository.isUserLoggedIn();
    if (loggedIn == true) {
      colors = await colorsRepository.fetchColors();
    }
  }

  @override
  MyAppConfiguration? get currentConfiguration {
    if (loggedIn == false) {
      return MyAppConfiguration.login();
    } else if (loggedIn == null) {
      return MyAppConfiguration.splash();
    } else if (show404 == true) {
      return MyAppConfiguration.unknown();
    } else if (selectedColorCode == null) {
      return MyAppConfiguration.home();
    } else if (selectedShapeBorderType == null) {
      return MyAppConfiguration.color(selectedColorCode);
    } else if (selectedShapeBorderType != null) {
      return MyAppConfiguration.shapeBorder(
          selectedColorCode, selectedShapeBorderType);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Page> stack;
    final loggedIn = this.loggedIn;
    final colors = this.colors;
    if (show404 == true) {
      stack = _unknownStack;
    } else if (loggedIn == null || (loggedIn && colors == null)) {
      stack = _splashStack;
    } else if (loggedIn && colors != null) {
      stack = _loggedInStack(colors);
    } else {
      stack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: stack,
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) return false;
    if (selectedShapeBorderType == null) selectedColorCode = null;
    selectedShapeBorderType = null;
    return true;
  }

  List<Page> get _splashStack {
    String? process;
    if (loggedIn == null) {
      process = 'Checking login state...';
    } else if (colors == null) {
      process = 'Fetching colors...';
    } else {
      process = "Unidentified process";
    }
    return [
      SplashPage(process: process),
    ];
  }

  List<Page> get _unknownStack => [const UnknownPage()];

  List<Page> get _loggedOutStack => [
        LoginPage(onLogin: () async {
          loggedIn = true;
          colors = await colorsRepository.fetchColors();
        })
      ];

  List<Page> _loggedInStack(List<Color> colors) {
    void onLogout() async {
      loggedIn = false;
    }

    final selectedShapeBorderType = this.selectedShapeBorderType;
    final selectedColorCode = this.selectedColorCode;
    return [
      HomePage(
        onColorTap: (String colorCode) {
          this.selectedColorCode = colorCode;
        },
        colors: colors,
        onLogout: onLogout,
      ),
      if (selectedColorCode != null)
        ColorPage(
          selectedColorCode: selectedColorCode,
          onShapeTap: (ShapeBorderType shapeBorderType) {
            this.selectedShapeBorderType = shapeBorderType;
          },
          onLogout: onLogout,
        ),
      if (selectedColorCode != null && selectedShapeBorderType != null)
        ShapePage(
          colorCode: selectedColorCode,
          shapeBorderType: selectedShapeBorderType,
          onLogout: onLogout,
        )
    ];
  }

  @override
  Future<void> setNewRoutePath(MyAppConfiguration configuration) async {
    if (configuration.unknown) {
      show404 = true;
    } else if (configuration.isHomePage ||
        configuration.isLoginPage ||
        configuration.isSplashPage) {
      show404 = false;
      selectedColorCode = null;
      selectedShapeBorderType = null;
    } else if (configuration.isColorPage) {
      show404 = false;
      selectedColorCode = configuration.colorCode;
      selectedShapeBorderType = null;
    } else if (configuration.isShapePage) {
      show404 = false;
      selectedColorCode = configuration.colorCode;
      selectedShapeBorderType = configuration.shapeBorderType;
    } else {
      print(' Could not set new route');
    }
  }

  _clear() {
    selectedColorCode = null;
    selectedShapeBorderType = null;
    colors = null;
    show404 = null;
  }

  bool _isValidColor(List<Color> colors, String colorCode) {
    final List<String> colorCodes = colors.map((e) {
      return e.toHex();
    }).toList();
    return colorCodes.contains(colorCode);
  }
}
