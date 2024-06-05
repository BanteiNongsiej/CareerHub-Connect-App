import 'dart:io';
import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
  String imagePath = '';
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

  void selectImage() {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton.icon(
            icon: Icon(Icons.camera_alt),
            label: Text('Camera'),
            onPressed: () {
              _pickImage(ImageSource.camera);
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.photo),
            label: Text('Gallery'),
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[800],
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Handle the picked image file
      print('Picked image: ${pickedFile.path}');
    }
  }

  Future<void> pickResume() async {
    // FilePickerResult? result=await FilePiker.platform.pickFiles();
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
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  right: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.black),
                      onPressed: () {
                        selectImage();
                      },
                    ),
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
                      pickResume();
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
