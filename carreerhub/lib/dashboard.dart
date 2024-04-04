import 'package:carreerhub/Add%20Job/add_job.dart';
import 'package:carreerhub/chatbox.dart';
import 'package:carreerhub/Home/home_page.dart';
import 'package:carreerhub/Add%20Job/job_post_form.dart';
import 'package:carreerhub/notification.dart';
import 'package:carreerhub/Profile/profile.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    tabController =
        TabController(length: 5, vsync: this, initialIndex: _currentIndex);
    super.initState();
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
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          const HomePageScreen(),
          const ChatBoxScreen(),
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
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble),
            selectedColor: Colors.black,
            // unSelectedColor: Cblack,
            backgroundColor: Colors.black,
            title: const Text('Chat'),
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
