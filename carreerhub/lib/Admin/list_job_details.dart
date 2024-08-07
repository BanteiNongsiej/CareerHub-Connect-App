import 'dart:convert';
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:carreerhub/helper/commonhelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';

class ListJobsDetails extends StatefulWidget {
  final int jobId;

  ListJobsDetails({required this.jobId});

  @override
  State<ListJobsDetails> createState() => _ListJobsDetailsState();
}

class _ListJobsDetailsState extends State<ListJobsDetails> {
  Job? job;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(widget.jobId);
  }

  Future<void> fetchData(int jobId) async {
    final response = await http
        .get(Uri.parse('http://10.0.3.2:8000/api/dashboard/job/show/$jobId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          json.decode(response.body)['data'];
      setState(() {
        job = Job.fromJson(responseData);
        print(jobId);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load job details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: isLoading
          ? buildSkeletonLoader()
          : (job != null
              ? buildJobDetails()
              : Center(child: Text('Job not found'))),
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
          ],
        ),
      ),
    );
  }

  String formatSalary(
      String minSalary, String? maxSalary, String salaryPeriod) {
    if (maxSalary == null || maxSalary.isEmpty) {
      return '$minSalary per $salaryPeriod';
    } else {
      return '$minSalary-$maxSalary per $salaryPeriod';
    }
  }

  Widget buildJobDetails() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Title: ${job!.title}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          buildDetailRow('Company Name:', job!.name),
          buildDetailRow('Address:', job!.address),
          Divider(),
          buildDetailRow('Job Type:', job!.job_type),
          buildDetailRow(
            'Salary:',
            formatSalary(job!.min_salary, job!.max_salary, job!.salary_period),
          ),
          buildDetailRow('Shift Type:', job!.shift_type ?? 'Not specified'),
          buildDetailRow('Number of People:', job!.no_people),
          buildDetailRow('Experience Requirement:',
              job!.experience_req ?? 'Not specified'),
          buildDetailRow('Qualification Requirement:',
              job!.qualification_req ?? 'Not specified'),
          buildDetailRow('Skills:', job!.skills ?? 'Not specified'),
          SizedBox(height: 16),
          Divider(),
          Text(
            'Job Description:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            job!.description,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  popup(context); // Add to bookmarks button pressed
                },
                icon: Icon(
                  Icons.delete,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void popup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are you sure?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                deletejob();
              },
              child: Text('delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deletejob() async {
    try {
      final url = Platform.isAndroid
          ? 'http://10.0.3.2:8000/api/dashboard/job/delete/${widget.jobId}'
          : 'http://localhost:8000/api/dashboard/job/delete/${widget.jobId}';
      print('Deleting job with URL: $url'); // Debug print

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
        Navigator.of(context)
            .pop(); // Close the popup after successful deletion
        CommonHelper.animatedSnackBar(
          context,
          'Job has been deleted successfully',
          AnimatedSnackBarType.success,
        );
      } else {
        CommonHelper.animatedSnackBar(
          context,
          'Job deletion failed',
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
