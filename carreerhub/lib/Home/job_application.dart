import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JobApplication extends StatefulWidget {
  final int jobId;
  const JobApplication({required this.jobId});

  @override
  State<JobApplication> createState() => _JobApplicationState();
}

late int userId;
late String userEmail = '';
late String resume = '';

class _JobApplicationState extends State<JobApplication> {
  Job? job;
  bool isLoading = true;
  List<ApplicationRecord> applicationRecords = [];
  String? error;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4));
    fetchData(widget.jobId);
  }

  Future getUserDetails() async {}

  Future<void> fetchData(int jobId) async {
    try {
      userId = await UserIdStorage.getUserId() as int;
      final userData = await ApiService.getUserDetail(userId);
      userEmail = await userData['email'] ?? '';
      resume = await userData['resume'] ?? '';
      //print(userData);
      final urlJob = Platform.isAndroid
          ? 'http://10.0.3.2:8000/api/dashboard/job/show/$jobId'
          : 'http://localhost:8000/api/dashboard/job/show/$jobId';
      final response = await http.get(Uri.parse(urlJob));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseuser =
            json.decode(response.body)['data'];
        setState(() {
          job = Job.fromJson(responseuser);
          print('Job Id :${jobId}');
          print('User Id :${userId}');
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load job details');
      }

      final urlApplication = Platform.isAndroid
          ? 'http://10.0.3.2:8000/api/dashboard/job/view-application/$jobId'
          : 'http://localhosts:8000/api/dashboard/job/view-application/$jobId';
      final applicationResponse = await http.get(Uri.parse(urlApplication));
      print(
          'Application Details Response Status: ${applicationResponse.statusCode}');
      print('Application Details Response Body: ${applicationResponse.body}');
      if (applicationResponse.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(applicationResponse.body)['data'];

        setState(() {
          applicationRecords = responseData
              .map((record) => ApplicationRecord.fromJson(record))
              .toList();
          isLoading = false;
        });
      } else if (applicationResponse.statusCode == 404) {
        setState(() {
          error = 'No application records found for this job';
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load application details');
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load data. Please try again later.';
        print(e);
        isLoading = false;
      });
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
                    'Application',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  buildApplicationDetails(),
                ],
              ),
            ),
    );
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

  Widget buildApplicationDetails() {
    if (applicationRecords.isEmpty) {
      return Text(error ?? 'No application records found for this job');
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Candidate Email')),
            DataColumn(label: Text('Resume')),
            DataColumn(label: Text('Application Date')),
          ],
          rows: applicationRecords.map((record) {
            return DataRow(
              cells: [
                DataCell(Center(child: Text(record.candidate_email))),
                DataCell(
                  Center(
                    child: InkWell(
                      onTap: () {
                        viewResume(record.candidate_id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.remove_red_eye, color: Colors.blue),
                          SizedBox(width: 4),
                          Text('Resume', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                ),
                DataCell(Center(child: Text(record.applicationDate))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void downloadResume(String resumeUrl) {
    // Implement your resume download logic here
    print('Downloading resume: $resumeUrl');
  }

  void viewResume(int candidate_id) async {
    print(candidate_id);
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
          ? 'http://10.0.3.2:8000/api/dashboard/job/viewResume/$candidate_id'
          : 'http://localhost:8000/api/dashboard/job/viewResume/$candidate_id';

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
              content: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: double.maxFinite,
                  height: 500, // Adjust the height as needed
                  child: PDFView(
                    filePath: tempFile.path,
                  ),
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

class ApplicationRecord {
  final int candidate_id;
  final int jobId;
  final candidate_email;
  final resume;
  final String applicationDate;
  final String originalFilename;

  ApplicationRecord({
    required this.candidate_id,
    required this.jobId,
    required this.candidate_email,
    required this.resume,
    required this.applicationDate,
    required this.originalFilename,
  });

  factory ApplicationRecord.fromJson(Map<String, dynamic> json) {
    return ApplicationRecord(
      candidate_id: json['candidate_id'] ?? 0,
      jobId: json['job_id'] ?? 0,
      candidate_email: json['candidate_email'] ?? '',
      resume: json['resume'] ?? '',
      applicationDate: json['application_date'] ?? '',
      originalFilename: json['originalFilename'] ?? '',
    );
  }
}
