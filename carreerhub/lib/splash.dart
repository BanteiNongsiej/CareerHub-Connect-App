import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carreerhub/login.dart';

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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'Welcome to',
            //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            // ),
            Image.asset(
              'images/logo.png', // Provide the path to your logo image
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
