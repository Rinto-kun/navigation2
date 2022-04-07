import 'package:common/extensions/color_extensions.dart';
import 'package:common/model/shape_border_type.dart';
import 'package:common/widgets/app_bar_text.dart';
import 'package:flutter/material.dart';
import 'package:navigation2/stolen_demo/widgets/app_bar_back_button.dart';
import 'package:navigation2/stolen_demo/widgets/logout_fab.dart';
import 'package:navigation2/stolen_demo/viewmodels/auth_view_model.dart';
import 'package:navigation2/stolen_demo/viewmodels/colors_view_model.dart';
import 'package:navigation2/widgets/in_progress_message.dart';
import 'package:navigation2/widgets/shaped_button.dart';
import 'package:provider/provider.dart';

class ShapeScreen extends StatelessWidget {
  final String colorCode;
  final ShapeBorderType shapeBorderType;
  final VoidCallback onLogout;

  Color get color => colorCode.hexToColor();

  const ShapeScreen({
    Key? key,
    required this.colorCode,
    required this.shapeBorderType,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarText(
          appBarColor: color,
          text:
              '${shapeBorderType.stringRepresentation().toUpperCase()} #$colorCode ',
        ),
        leading: AppBarBackButton(color: color),
        backgroundColor: colorCode.hexToColor(),
      ),
      body: _body(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: LogoutFab(onLogout: onLogout, color: color),
    );
  }

  Widget _body(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final colorsViewModel = context.watch<ColorsViewModel>();
    bool inProgress;
    String? progressName;
    if (authViewModel.logingOut) {
      inProgress = true;
      progressName = "Logout";
    } else if (colorsViewModel.clearingColors) {
      inProgress = true;
      progressName = "Clearing colors";
    } else {
      inProgress = false;
      progressName = null;
    }
    return inProgress && progressName != null
        ? InProgressMessage(
            progressName: progressName, screenName: "ShapeScreen")
        : Center(
            child: ShapedButton(
              color: color,
              shapeBorderType: shapeBorderType,
            ),
          );
  }
}
