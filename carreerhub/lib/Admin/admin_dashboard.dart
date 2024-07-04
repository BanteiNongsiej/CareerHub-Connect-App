import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<dynamic> users = [];
  List<dynamic> jobs = [];
  bool isLoading = false;

  logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Padding(
            padding: EdgeInsets.only(top: 10.0), // Add padding to the top
            child: Text("Are you sure you want to logout?"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Set button color to black
              ),
              child: Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading =
                      true; // Set isLoading to true when button is pressed
                });
                await Future.delayed(const Duration(seconds: 3), () {});
                await AuthTokenStorage.deleteToken();
                await UserIdStorage.deleteUserId();
                Navigator.pushNamed(context, '/login');
                setState(() {
                  isLoading = false; // Set isLoading to false after 3 seconds
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Set button color to white
              ),
              child: isLoading
                  ? SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      'Logout',
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Color.fromARGB(255, 142, 233, 237),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/listjobs');
                  },
                  child: Text('Show all Jobs'),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/listusers');
                  },
                  child: Text('Show Users'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
