
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'color/color.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  void initState() {
    super.initState();
    // Wait for a few seconds and then navigate to the main screen
    _navigateToMainScreen();
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Adjus the duration as needed
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Set the background color of your splash screen
        child: Center(
          child: LoadingAnimationWidget.bouncingBall(color: CustomColor.primary, size: 100)
        ),
      ),
    );
  }
}
