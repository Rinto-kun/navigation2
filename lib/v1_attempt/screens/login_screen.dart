import 'package:flutter/material.dart';
import '../constants/paths.dart';
import '../navigation/fade_animation.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLoginUser;
  final Function() onLoginEmployee;
  const LoginScreen({Key? key, required this.onLoginUser, required this.onLoginEmployee}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  FadeAnimationPage page() {
    return FadeAnimationPage(
      name: Paths.login,
      key: const ValueKey(Paths.login),
      child: LoginScreen(onLoginUser: onLoginUser, onLoginEmployee: onLoginEmployee),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Login Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: widget.onLoginUser, child: const Text("CLIENT")),
            ElevatedButton(
                onPressed: widget.onLoginEmployee, child: const Text("EMPLOYEE")),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(
                builder: (BuildContext context) => const RegisterScreen()));
            },
            child: const Text("Register")),
        ElevatedButton(
            onPressed: () {}, child: const Text("Forgotten password")),
      ],
    );
  }
}