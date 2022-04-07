import 'package:common/dimens/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:navigation2/stolen_demo/viewmodels/auth_view_model.dart';
import 'package:navigation2/widgets/in_progress_message.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginScreen({Key? key, required this.onLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: authViewModel.logingIn
            ? const InProgressMessage(
                progressName: "Login", screenName: "LoginScreen")
            : ElevatedButton(
                onPressed: () async {
                  final authViewModel = context.read<AuthViewModel>();
                  final result = await authViewModel.login();
                  if (result == true) {
                    onLogin();
                  } else {
                    authViewModel.logingIn = false;
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(AppDimens.SIZE_SPACING_MEDIUM),
                  child: Text('Log in'),
                ),
              ),
      ),
    );
  }
}
