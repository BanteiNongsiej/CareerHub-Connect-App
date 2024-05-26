import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';

class JobDetails extends StatefulWidget {
  final int jobId;

  JobDetails({required this.jobId});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
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
        print(job);
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

  Widget buildJobDetails() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Title: ${job!.title}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Company Name: ${job!.name}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Address: ${job!.address}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Job Type: ${job!.job_type}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Minimum Salary: ${job!.min_salary}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Maximum Salary: ${job!.max_salary ?? 'Not specified'}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Salary Period: ${job!.salary_period}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Shift Type: ${job!.shift_type ?? 'Not specified'}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Number of People: ${job!.no_people}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Experience Requirement: ${job!.experience_req ?? 'Not specified'}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Qualification Requirement: ${job!.qualification_req ?? 'Not specified'}',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 8),
          // Text(
          //   'Skills: ${job!.skills ?? 'Not specified'}',
          //   style: TextStyle(fontSize: 15),
          // ),
          SizedBox(height: 8),
          Text(
            'Job Description:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            job!.description,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Apply button pressed
                },
                child: Text(
                  'Apply',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Add to bookmarks button pressed
                },
                icon: Icon(
                  Icons.bookmark,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
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
  // final String? skills;
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
    // this.skills,
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
      // skills: json['skills'] ?? '',
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
      // 'skills': skills,
      'description': description,
    };
  }
}