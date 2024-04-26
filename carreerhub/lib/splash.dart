import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:carreerhub/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:carreerhub/token.dart';
import 'package:carreerhub/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'images/logo.png',
      splashIconSize: double.infinity,
      nextScreen: CheckTokenWidget(), // Call the widget that checks token
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
    );
  }
}

class CheckTokenWidget extends StatefulWidget {
  @override
  _CheckTokenWidgetState createState() => _CheckTokenWidgetState();
}

class _CheckTokenWidgetState extends State<CheckTokenWidget> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    String? token = await AuthTokenStorage.getToken();
    Widget nextScreen = token != null ? Dashboard() : Login();
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: nextScreen,
        type: PageTransitionType.rightToLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // You can return any widget here since it will be replaced
    // with the next screen after 3 seconds.
    return Container();
  }
}
