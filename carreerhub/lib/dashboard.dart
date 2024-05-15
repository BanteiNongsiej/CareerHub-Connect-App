import 'package:carreerhub/Add%20Job/add_job.dart';
import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/chatbox.dart';
import 'package:carreerhub/Home/home_page.dart';
import 'package:carreerhub/Add%20Job/job_post_form.dart';
import 'package:carreerhub/notification.dart';
import 'package:carreerhub/Profile/profile.dart';
import 'package:carreerhub/token.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int _currentIndex =
      0; //store which menu you selected from bottom navigation bar
  bool isLoading = false;
  @override
  void initState() {
    tabController =
        TabController(length: 5, vsync: this, initialIndex: _currentIndex);
    super.initState();
  }

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
        backgroundColor: Color.fromARGB(255, 142, 233, 237),
        title: const Text(
          "CareerHub",
          style: TextStyle(
              color: Color.fromARGB(255, 8, 30, 228),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 26
              //fontFamily:AutofillHints.countryName
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          const HomePageScreen(),
          AddJobScreen(),
          NotificationScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: const Color.fromARGB(255, 142, 233, 237),
        currentIndex: _currentIndex,
        onTap: (tabIndex) {
          setState(() {
            _currentIndex = tabIndex;
            tabController.animateTo(_currentIndex);
          });
        },
        option: AnimatedBarOptions(
          iconSize: 28,
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.Default,
          //opacity: 2,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.house_outlined,
            ),
            selectedIcon: const Icon(Icons.house_rounded),
            selectedColor: Colors.black,
            backgroundColor: Colors.black,
            title: const Text('Home'),
            //badge: const Text('9+'),
            //showBadge: true,
          ),
          BottomBarItem(
              icon: const Icon(
                Icons.add_box_outlined,
              ),
              selectedIcon: const Icon(
                Icons.add_box,
              ),
              backgroundColor: Colors.black,
              selectedColor: Colors.black,
              title: const Text('Add Job')),
          BottomBarItem(
              icon: const Icon(
                Icons.notifications_none,
              ),
              selectedIcon: const Icon(
                Icons.notifications,
              ),
              backgroundColor: Colors.black,
              selectedColor: Colors.black,
              title: const Text('Notification')),
          BottomBarItem(
              icon: const Icon(
                Icons.person_outline,
              ),
              selectedIcon: const Icon(
                Icons.person,
              ),
              backgroundColor: Colors.black,
              selectedColor: Colors.black,
              title: const Text('Profile')),
        ],
      ),
    );
  }
}
