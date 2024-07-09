//import 'dart:js';

import 'package:carreerhub/Add%20Job/my_job.dart';
import 'package:carreerhub/Add%20Job/job_post.dart';
import 'package:carreerhub/Admin/admin_dashboard.dart';
import 'package:carreerhub/Admin/list_job.dart';
import 'package:carreerhub/Admin/list_job_details.dart';
import 'package:carreerhub/Admin/user_list.dart';
import 'package:carreerhub/Home/apply_job.dart';
import 'package:carreerhub/Home/bookmarkjob.dart';
import 'package:carreerhub/Home/job_application.dart';
import 'package:carreerhub/Home/job_details.dart';
import 'package:carreerhub/Resume/build_resume.dart';
import 'package:carreerhub/Resume/review_resume.dart';
import 'package:carreerhub/chatbox.dart';
import 'package:carreerhub/dashboard.dart';
import 'package:carreerhub/Home/home_page.dart';
import 'package:carreerhub/notification.dart';
import 'package:carreerhub/Profile/profile.dart';
import 'package:carreerhub/provider/userprovider.dart';
import 'package:carreerhub/auth/register.dart';
import 'package:carreerhub/splash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carreerhub/auth/login.dart';
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
        '/jobpost': (context) => JobPost(),
        '/bookmarkjob': (context) => JobBookmarkScreen(),
        '/jobdetails': (context) => JobDetails(
            jobId: ModalRoute.of(context)!.settings.arguments as int),
        '/buildresume': (context) => BuildResume(),
        '/reviewresume': (context) => ReviewResume(),
        '/admindashboard': (context) => AdminDashboard(),
        '/listjobs': (context) => ListJobs(),
        '/listjobdetails': (context) => ListJobsDetails(
            jobId: ModalRoute.of(context)!.settings.arguments as int),
        '/applyingjob': (context) => ApplyJobScreeen(
            jobId: ModalRoute.of(context)!.settings.arguments as int),
        '/job_application': (context) => JobApplication(
            jobId: ModalRoute.of(context)!.settings.arguments as int),
        '/listusers': (context) => ListUsers(),
      },
    );
  }
}
