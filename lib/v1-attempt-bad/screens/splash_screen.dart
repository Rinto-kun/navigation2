import 'package:flutter/material.dart';
import '../navigation/route_information_parser.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static MaterialPage page() {
    return const MaterialPage(
      name: Paths.splash,
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