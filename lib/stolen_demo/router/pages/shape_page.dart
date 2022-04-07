import 'package:common/model/shape_border_type.dart';
import 'package:flutter/material.dart';

import '../../screens/shape_screen.dart';

class ShapePage extends Page {
  final String colorCode;
  final ShapeBorderType shapeBorderType;
  final VoidCallback onLogout;

  ShapePage({
    required this.shapeBorderType,
    required this.colorCode,
    required this.onLogout,
  }) : super(key: ValueKey("$colorCode$shapeBorderType"));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return ShapeScreen(
          colorCode: colorCode,
          shapeBorderType: shapeBorderType,
          onLogout: onLogout,
        );
      },
    );
  }
}
