import 'package:flutter/material.dart';
import 'package:navigation2/v1_attempt/navigation/fade_animation.dart';
import '../constants/paths.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static FadeAnimationPage page() {
    return const FadeAnimationPage(
      // name: Paths.splash,
        key: ValueKey(Paths.splash),
        child: SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: const Center(child: Text("S P L A S H    P A G E")),
    );
  }
}