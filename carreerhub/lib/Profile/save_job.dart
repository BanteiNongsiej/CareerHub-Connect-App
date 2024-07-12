//import 'package:carreerhub/Home/job_details.dart';
import 'package:carreerhub/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:carreerhub/GetuserId.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({Key? key}) : super(key: key);

  @override
  _SavedJobsScreenState createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  List<Job> savedJobs = [];
  List<Map<String, dynamic>> dataList = []; //List to store data
  bool isLoading = true;
  int user_id = 0;

  @override
  void initState() {
    super.initState();
    fetchSavedJobs();
  }

  Future<void> fetchSavedJobs() async {
    user_id = await UserIdStorage.getUserId() as int;
    print(user_id);
    final response = await http.get(Uri.parse(
        'http://10.0.3.2:8000/api/dashboard/job/viewAllSaveJob/$user_id'));
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        dataList.clear();
        for (final entry in responseData) {
          dataList.add(Map<String, dynamic>.from(entry));
          savedJobs = dataList
              .map((data) => Job(
                    id: data['id'] ?? '',
                    title: data['title'] ?? '',
                    name: data['name'] ?? '',
                    address: data['address'] ?? '',
                    job_type: data['job_type'] ?? '',
                    min_salary: data['min_salary'] ?? '',
                    max_salary: data['max_salary'] ?? '',
                    description: data['description'] ?? '',
                    shift_type: data['shift_type'] ?? '',
                  ))
              .toList();
        }
        isLoading = false;
        print(address);
      });
    } else {
      throw Exception('Failed to loads jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Jobs'),
      ),
      body: isLoading
          ? Skeletonizer(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => _buildSkeletonCard(),
              ),
            )
          : ListView.builder(
              itemCount: savedJobs.length,
              itemBuilder: (context, index) {
                final job = savedJobs[index];
                return JobCard(job: job);
              },
            ),
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 200.0,
              height: 16.0,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 120.0,
              height: 16.0,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 240.0,
              height: 16.0,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 240, 245, 248),
      shadowColor: Color.fromARGB(255, 215, 50, 9),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        onTap: () {
          Navigator.pushNamed(context, '/jobdetails', arguments: job.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(job.name),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 16.0,
                        color: Color.fromARGB(255, 140, 61, 61),
                      ),
                      const SizedBox(width: 4.0),
                      Flexible(
                        child: Text(
                          job.address,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 227, 225, 216),
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(job.job_type),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 227, 225, 216),
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(job.shift_type),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 227, 225, 216),
                        child: {job.max_salary}.isEmpty
                            ? Text('\u{20B9}${job.min_salary}')
                            : Text(
                                '\u{20B9}${job.min_salary} - \u{20B9}${job.max_salary}'),
                      ),
                    ],
                  ),
                  Text(
                    job.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
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
  final String max_salary;
  final String description;
  final String shift_type; // Ensure this is String, not String?

  Job({
    required this.id,
    required this.title,
    required this.name,
    required this.address,
    required this.job_type,
    required this.min_salary,
    required this.max_salary,
    required this.description,
    required this.shift_type, // Non-nullable String
  });

  // Factory method to create Job object from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      job_type: json['job_type'] ?? '',
      min_salary: json['min_salary']?.toString() ?? '',
      max_salary: json['max_salary']?.toString() ?? '',
      description: json['description'] ?? '',
      shift_type: json['shift_type'] ??
          '', // Ensure it defaults to an empty string if null
    );
  }
}
