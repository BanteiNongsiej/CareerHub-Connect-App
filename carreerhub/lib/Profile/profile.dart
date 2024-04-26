import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            color: Colors.grey[300],
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('images/no_profile.jpg'),
                    // You can add an image here, or text if no image available
                    // backgroundImage: AssetImage('path_to_image'),
                    child: Text('User', style: TextStyle(fontSize: 20)),
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
          SizedBox(height: 20),
          Text(
            'Name: John Doe',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Email: johndoe@example.com',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          // Add more widgets/columns as needed for additional information
          // Example:
          // Column(
          //   children: [
          //     Text('Additional Information', style: TextStyle(fontSize: 20)),
          //     // Additional widgets here
          //   ],
          // ),
          // SizedBox(height: 20),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your build resume functionality here
                      },
                      child: Text('Build Resume'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/bookmarkjob');
                      },
                      child: Text('Bookmark Job'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Add your logout functionality here
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
