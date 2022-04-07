import 'package:common/model/shape_border_type.dart';
import 'package:flutter/material.dart';

import '../../screens/color_screen.dart';

class ColorPage extends Page {
  final Function(ShapeBorderType) onShapeTap;
  final String selectedColorCode;
  final VoidCallback onLogout;

  ColorPage({
    required this.onLogout,
    required this.selectedColorCode,
    required this.onShapeTap,
  }) : super(key: ValueKey(selectedColorCode));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return ColorScreen(
          onShapeTap: onShapeTap,
          colorCode: selectedColorCode,
          onLogout: onLogout,
        );
      },
    );
  }
}
