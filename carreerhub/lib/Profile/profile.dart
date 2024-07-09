import 'dart:io';
import 'dart:typed_data';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/helper/commonhelper.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:carreerhub/api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
late String resume = '';

class _ProfileScreenState extends State<ProfileScreen> {
  String imagePath = '';
  File? selectedFile;
  String? filename;
  PlatformFile? pickedfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 3));
    await getUserdetails();
    setState(() {
      isLoading = false;
    });
  }

  getUserdetails() async {
    userId = await UserIdStorage.getUserId() as int;
    final userData = await ApiService.getUserDetail(userId);
    userEmail = await userData['email'] ?? '';
    username = await userData['name'] ?? '';
    address = await userData['address'] ?? '';
    mobile_number = await userData['mobile_number'] ?? '';
    resume = await userData['resume'] ?? '';
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    setState(() {
      isLoading = true;
    });
    if (result != null && result.files.single.path != null) {
      filename = result.files.first.name;
      pickedfile = result.files.first;
      selectedFile = File(pickedfile!.path.toString());
      print('File Name $filename');
      print(userId);

      // Show loading indicator
      await Future.delayed(Duration(seconds: 3));
      // Upload the resume
      await uploadResume(selectedFile!);
      // Hide loading indicator
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteResume() async {
    try {
      final url = Platform.isAndroid
          ? 'http://10.0.3.2:8000/api/dashboard/deleteResumeFile/$userId'
          : 'http://localhost:8000/api/dashboard/deleteResumeFile/$userId';
      print('Deleting resume with URL: $url'); // Debug print

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        setState(() {
          resume = ''; // Clear the resume field in the UI
        });
        CommonHelper.animatedSnackBar(
          context,
          'Resume has been deleted successfully',
          AnimatedSnackBarType.success,
        );
      } else {
        CommonHelper.animatedSnackBar(
          context,
          'Resume deletion failed',
          AnimatedSnackBarType.error,
        );
      }
    } catch (e) {
      print('Error caught in catch block: $e'); // Debug print
      CommonHelper.animatedSnackBar(
        context,
        'An error occurred: $e',
        AnimatedSnackBarType.error,
      );
    }
  }

  Future<void> uploadResume(File file) async {
    final url = Platform.isAndroid
        ? 'http://10.0.3.2:8000/api/dashboard/storeResumeFile/$userId'
        : 'http://localhost:8000/api/dashboard/storeResumeFile/$userId';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    var mimeType = lookupMimeType(file.path);
    // var fileName = file.path.split('/').last;

    request.files.add(await http.MultipartFile.fromPath(
      'resume',
      file.path,
      contentType: MediaType.parse(mimeType!), // Parse MIME type correctly
      filename: filename,
    ));
    request.fields['filename'] = filename ?? '';
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Resume uploaded successfully');
    } else {
      print('Failed to upload resume');
    }
  }

  Future<void> viewResume() async {
    print(user_id);
    try {
      // Show CircularProgressIndicator while loading
      showDialog(
        context: context,
        barrierDismissible: false, // prevent closing dialog by tapping outside
        builder: (context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loading Resume...',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

      // Simulate delay for 3 seconds (remove this in production)
      await Future.delayed(Duration(seconds: 3));

      // Construct the API URL for fetching the resume
      final url = Platform.isAndroid
          ? 'http://10.0.3.2:8000/api/dashboard/ViewResume/$userId'
          : 'http://localhost:8000/api/dashboard/ViewResume/$userId';

      final response = await http.get(Uri.parse(url));
      print(response.body);

      if (response.statusCode == 200) {
        // Get the file bytes
        final Uint8List fileBytes = response.bodyBytes;

        // Write the file to a temporary directory
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/resume.pdf');
        await tempFile.writeAsBytes(fileBytes);

        // Close the CircularProgressIndicator dialog
        Navigator.of(context).pop();

        // Show the PDF in a dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Resume'),
              content: Container(
                width: double.maxFinite,
                height: 500, // Adjust the height as needed
                child: PDFView(
                  filePath: tempFile.path,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to load resume');
      }
    } catch (e) {
      // Handle errors
      print('Error loading resume: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load resume. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Skeletonizer(
              enabled: isLoading,
              child: Column(
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
                              backgroundImage:
                                  AssetImage('images/no_profile.jpg'),
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        if (resume.isNotEmpty) ...[
                          InkWell(
                            onTap: () => {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color.fromARGB(255, 219, 218, 218),
                              ),
                              //color: Color.fromARGB(255, 219, 218, 218),
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons
                                            .filePdf, // Assuming the resume is in PDF format
                                        size: 30,
                                        color: Colors
                                            .black, // Customize the icon color if needed
                                      ),
                                      SizedBox(
                                          width:
                                              10), // Adjust spacing between icon and text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$resume',
                                              style: TextStyle(fontSize: 16),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (String value) {
                                          if (value == 'edit') {
                                            pickResume(); // Implement your edit functionality here
                                          } else if (value == 'delete') {
                                            deleteResume(); // Implement your delete functionality here
                                          } else if (value == 'view') {
                                            viewResume(); // Call viewResume function here
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'edit',
                                            child: ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text('Edit'),
                                            ),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text('Delete'),
                                            ),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'view',
                                            child: ListTile(
                                              leading: Icon(Icons
                                                  .remove_red_eye_outlined),
                                              title: Text('View Resume'),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ] else ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  selectedFile == null ? pickResume : null,
                              child: selectedFile == null
                                  ? const Text(
                                      'Upload Resume',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  : Text(
                                      '${selectedFile!.path.split('/').last}',
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (selectedFile != null)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : pickResume,
                                    child: isLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                              SizedBox(width: 16),
                                              Text('Uploading...'),
                                            ],
                                          )
                                        : const Text(
                                            'Update',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          if (selectedFile == null) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/buildresume');
                                },
                                child: const Text(
                                  'Build Resume',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ],
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
                            textAlign: TextAlign.center,
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
            )
          : Column(
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
                            backgroundImage:
                                AssetImage('images/no_profile.jpg'),
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
                  padding: EdgeInsets.all(15),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      if (resume.isNotEmpty) ...[
                        InkWell(
                          onTap: () => {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromARGB(255, 219, 218, 218),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.filePdf,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$resume',
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (String value) {
                                        if (value == 'edit') {
                                          pickResume();
                                        } else if (value == 'delete') {
                                          deleteResume();
                                        } else if (value == 'view') {}
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'edit',
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('Edit'),
                                          ),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'delete',
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('Delete'),
                                          ),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'view',
                                          child: ListTile(
                                            leading: Icon(
                                                Icons.remove_red_eye_outlined),
                                            title: Text('View Resume'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: selectedFile == null ? pickResume : null,
                            child: selectedFile == null
                                ? const Text(
                                    'Upload Resume',
                                    style: TextStyle(fontSize: 16),
                                  )
                                : Text(
                                    '${selectedFile!.path.split('/').last}',
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (selectedFile != null)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : pickResume,
                                  child: isLoading
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                            SizedBox(width: 16),
                                            Text('Uploading...'),
                                          ],
                                        )
                                      : const Text(
                                          'Update',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        if (selectedFile == null) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/buildresume');
                              },
                              child: const Text(
                                'Build Resume',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
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
                    onPressed: () {},
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
