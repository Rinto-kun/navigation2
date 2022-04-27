import 'package:flutter/material.dart';

import '../constants/paths.dart';
import '../navigation/fade_animation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

  FadeAnimationPage page() {
    return const FadeAnimationPage(
      name: Paths.login,
      key: ValueKey(Paths.login),
      child: RegisterScreen(),
    );
  }

}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            const Text("This is registration page!"),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Go back"))
          ],
    ));
  }
}