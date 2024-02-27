//import 'dart:js';

import 'package:carreerhub/dashboard.dart';
import 'package:carreerhub/provider/userprovider.dart';
import 'package:carreerhub/register.dart';
import 'package:carreerhub/splash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carreerhub/login.dart';
import 'package:carreerhub/api.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Portal App',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/dashboard': (context) => const Dashboard(),
        '/splash': (context) => const SplashScreen(),
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
      },
    );
  }
}
