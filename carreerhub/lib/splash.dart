import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:carreerhub/register.dart';
import 'package:flutter/material.dart';
import 'package:carreerhub/login.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay the navigation to the Register screen for 2 seconds
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, '/register'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'images/logo.png',
      splashIconSize: double.infinity,
      nextScreen: const Register(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
    );
  }
}
