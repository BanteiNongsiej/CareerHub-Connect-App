import 'dart:convert';
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/api.dart';
import 'package:carreerhub/helper/commonhelper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ApplyJobScreeen extends StatefulWidget {
  final int jobId;
  const ApplyJobScreeen({required this.jobId});

  @override
  State<ApplyJobScreeen> createState() => _ApplyJobScreeenState();
}

late int userId;
late String userEmail = '';
late String resume = '';

class _ApplyJobScreeenState extends State<ApplyJobScreeen> {
  Job? job;
  String imagePath = '';
  File? selectedFile;
  String? filename;
  PlatformFile? pickedfile;
  bool isLoading = true;
  bool hasApplied = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3));
    fetchData(widget.jobId);
  }

  Future getUserDetails() async {}

  Future<void> fetchData(int jobId) async {
    print(jobId);
    userId = await UserIdStorage.getUserId() as int;
    final userData = await ApiService.getUserDetail(userId);
    userEmail = await userData['email'] ?? '';
    resume = await userData['resume'] ?? '';
    print(userData);
    await checkIfApplied(userId, widget.jobId);
    final response = await http
        .get(Uri.parse('http://10.0.3.2:8000/api/dashboard/job/show/$jobId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          json.decode(response.body)['data'];
      setState(() {
        job = Job.fromJson(responseData);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load job details');
    }
  }

  Future<void> checkIfApplied(int userId, int jobId) async {
    final response = await http.get(Uri.parse(
        'http://10.0.3.2:8000/api/dashboard/job/check-application/$userId/$jobId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        hasApplied = responseData['hasApplied'];
      });
    } else {
      throw Exception('Failed to check application status');
    }
  }

  Future<void> pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        isLoading = true;
      });
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
      setState(() {
        resume =
            filename ?? ''; // Set the resume variable with the new filename
        isLoading = false; // Hide the loading indicator
      });
      CommonHelper.animatedSnackBar(
        context,
        'Resume uploaded successfully',
        AnimatedSnackBarType.success,
      );
    } else {
      print('Failed to upload resume');
      setState(() {
        isLoading = false; // Hide the loading indicator
      });
      CommonHelper.animatedSnackBar(
        context,
        'Failed to upload resume',
        AnimatedSnackBarType.error,
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${job?.title ?? 'Loading...'}'),
      ),
      body: isLoading
          ? buildSkeletonLoader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job!.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(job!.address),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return buildJobDetailsModal();
                        },
                      );
                    },
                    child: Text(
                      'See more details',
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 16),
                  Text(
                    'Add CV to the employer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
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
                                        leading:
                                            Icon(Icons.remove_red_eye_outlined),
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
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: pickResume,
                                child: Text(
                                  'Upload Resume',
                                  style: TextStyle(fontSize: 16),
                                )),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: pickResume,
                                child: Text(
                                  'Build Resume',
                                  style: TextStyle(fontSize: 16),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: hasApplied
                          ? null
                          : () {
                              popupdialog(context);
                            },
                      child: Text(hasApplied ? 'Already Applied' : 'Apply'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void popupdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Submission'),
          content: Text('Are you sure you want to submit application?'),
          actions: [
            TextButton(
              onPressed: () {
                //print(skills);
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                applyJob();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> applyJob() async {
    final url = Platform.isAndroid
        ? 'http://10.0.3.2:8000/api/dashboard/job/applyjob/$userId/${widget.jobId}'
        : 'http://localhost:8000/api/dashboard/job/applyjob/$userId/${widget.jobId}';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Adding fields to the request
      request.fields['candidate_email'] = userEmail;

      // Adding file to the request
      if (selectedFile != null) {
        var mimeType = lookupMimeType(selectedFile!.path);
        request.files.add(await http.MultipartFile.fromPath(
          'resume',
          selectedFile!.path,
          contentType: MediaType.parse(mimeType!),
        ));
      } else {
        print(selectedFile);
        CommonHelper.animatedSnackBar(
          context,
          'Please upload a resume before applying',
          AnimatedSnackBarType.warning,
        );
        return;
      }

      // Sending the request
      var response = await request.send();
      // Handling the response
      if (response.statusCode == 201) {
        CommonHelper.animatedSnackBar(
          context,
          'Application submitted successfully',
          AnimatedSnackBarType.success,
        );
        Navigator.pushNamed(context, '/dashboard');
      } else {
        var responseData = await response.stream.bytesToString();
        var decodedResponse = json.decode(responseData);
        CommonHelper.animatedSnackBar(
          context,
          'Failed to submit application: ${decodedResponse['error']}',
          AnimatedSnackBarType.error,
        );
        print('Backend response: $decodedResponse');
      }
    } catch (e) {
      CommonHelper.animatedSnackBar(
        context,
        'An error occurred: $e',
        AnimatedSnackBarType.error,
      );
      print('Exception caught: $e');
    }
  }

  Widget buildJobDetailsModal() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Full job details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 8),
          buildJobDetails(job!),
        ],
      ),
    );
  }

  Widget buildJobDetails(Job job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailRow('Company Name:', job.name),
        buildDetailRow('Address:', job.address),
        buildDetailRow('Job Type:', job.job_type),
        buildDetailRow('Minimum Salary:', job.min_salary),
        buildDetailRow('Maximum Salary:', job.max_salary ?? 'Not specified'),
        buildDetailRow('Salary Period:', job.salary_period),
        buildDetailRow('Shift Type:', job.shift_type ?? 'Not specified'),
        buildDetailRow('Number of People:', job.no_people),
        buildDetailRow(
            'Experience Requirement:', job.experience_req ?? 'Not specified'),
        buildDetailRow('Qualification Requirement:',
            job.qualification_req ?? 'Not specified'),
        buildDetailRow('Skills:', job.skills ?? 'Not specified'),
        SizedBox(height: 16),
        Text(
          'Job Description:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(job.description, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSkeletonLoader() {
    return Skeletonizer(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: double.infinity, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(width: 150.0, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(
                width: double.infinity, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(width: 100.0, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(
                width: double.infinity, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(width: 120.0, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(
                width: double.infinity, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(width: 150.0, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(
                width: double.infinity, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 8),
            Container(width: 200.0, height: 24.0, color: Colors.grey[300]),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: 100, height: 40, color: Colors.grey[300]),
                Container(width: 40, height: 40, color: Colors.grey[300]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Job {
  final int id;
  final String title;
  final String name;
  final String address;
  final String job_type;
  final String min_salary;
  final String? max_salary;
  final String salary_period;
  final String? shift_type;
  final String no_people;
  final String? experience_req;
  final String? qualification_req;
  final String? skills;
  final String description;

  Job({
    required this.id,
    required this.title,
    required this.name,
    required this.address,
    required this.job_type,
    required this.min_salary,
    this.max_salary,
    required this.salary_period,
    this.shift_type,
    required this.no_people,
    this.experience_req,
    this.qualification_req,
    this.skills,
    required this.description,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      job_type: json['job_type'] ?? '',
      shift_type: json['shift_type'] ?? '',
      min_salary: json['min_salary'] ?? '',
      max_salary: json['max_salary'] ?? '',
      salary_period: json['salary_period'] ?? '',
      no_people: json['no_people'] ?? '',
      experience_req: json['experience_req'] ?? '',
      qualification_req: json['qualification_req'] ?? '',
      skills: json['skills'] ?? '',
      description: json['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Job{title: $title, name: $name, address: $address, job_type: $job_type, min_salary: $min_salary, description: $description}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'address': address,
      'job_type': job_type,
      'shift_type': shift_type,
      'min_salary': min_salary,
      'max_salary': max_salary,
      'salary_period': salary_period,
      'no_people': no_people,
      'qualification_req': qualification_req,
      'experience_req': experience_req,
      'skills': skills,
      'description': description,
    };
  }
}
