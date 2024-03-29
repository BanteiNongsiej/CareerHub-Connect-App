//import 'dart:js';

import 'package:carreerhub/add_job.dart';
import 'package:carreerhub/chatbox.dart';
import 'package:carreerhub/dashboard.dart';
import 'package:carreerhub/home_page.dart';
import 'package:carreerhub/job_post_form.dart';
import 'package:carreerhub/notification.dart';
import 'package:carreerhub/profile.dart';
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
      title: 'CareerHub Connect',
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
        '/homepage': (context) => const HomePageScreen(),
        '/addjob': (context) => AddJobScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/chatbox': (context) => const ChatBoxScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/jobpostform': (context) => JobPostFormScreen(),
      },
    );
  }
}
