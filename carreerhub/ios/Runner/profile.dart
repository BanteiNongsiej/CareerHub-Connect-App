import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

late int userId; // Declare userId as late, we'll initialize it in initState
late String userEmail = '';
late String username = '';
late String address = '';
late String mobile_number = '';

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    getUserdetails();
    super.initState();
  }

  getUserdetails() async {
    userId = await UserIdStorage.getUserId() as int;

    final userData = await ApiService.getUserDetail(userId);
    userEmail = await userData['email'] ?? '';
    username = await userData['name'] ?? '';
    address = await userData['address'] ?? '';
    mobile_number = await userData['mobile_number'] ?? '';
    print(userData);
  }

  void showProfileImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Stack(
              children: [
                Center(
                  child: Hero(
                    tag: 'profile-image',
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('images/no_profile.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 10,
                //   right: 10,
                //   child: IconButton(
                //     icon: Icon(Icons.edit, color: Colors.white, size: 30),
                //     onPressed: () {
                //       // Add your edit profile image functionality here
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 130,
            color: Colors.grey[300],
            child: Stack(
              children: [
                Positioned(
                  top: 80,
                  left: 15,
                  child: Text(
                    '$username',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 23,
                  right: 40,
                  child: GestureDetector(
                    onTap: showProfileImageDialog,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('images/no_profile.jpg'),
                      // You can add an image here, or text if no image available
                      // backgroundImage: AssetImage('path_to_image'),
                      //child: Text('User', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Edit Profile"),
                        value: "edit_profile",
                      ),
                    ],
                    onSelected: (value) {
                      if (value == "edit_profile") {
                        // Add your edit profile functionality here
                      }
                    },
                    icon: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(15), // Add padding for spacing
            //decoration: BoxDecoration(
            //border: Border.all(color: Colors.grey), // Add border for visual separation
            //borderRadius: BorderRadius.circular(10), // Add border radius for rounded corners
            //),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidEnvelope,
                      size: 20.0,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      '$userEmail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.phone,
                      size: 20.0,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      '$mobile_number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: 20.0,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: Text(
                        '$address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  "Resume",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your build resume functionality here
                    },
                    child: Text(
                      'Upload Resume',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: double.infinity, height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/buildresume');
                    },
                    child: Text(
                      'Build Resume',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add your build resume functionality here
              },
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.solidBookmark),
                  SizedBox(width: 8),
                  Text(
                    'Saved',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add your build resume functionality here
              },
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
