import 'dart:convert';

import 'package:carreerhub/GetuserId.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class AddJobScreen extends StatefulWidget {
  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  List<Map<String, dynamic>> dataList = []; // List to store data
  List<Job> jobList = [];
  bool isLoading = true;
  int user_id = 0;

  @override
  void initState() {
    super.initState();
    getUserId();
    // Simulating loading time with a delay of 3 seconds
    Future.delayed(Duration(seconds: 2), () {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('http://10.0.3.2:8000/api/dashboard/job/findjob/$user_id'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        dataList.clear();
        for (final entry in responseData) {
          dataList.add(Map<String, dynamic>.from(entry));
        }
        jobList = dataList
            .map((data) => Job(
                  title: data['title'] ?? '',
                  company_name: data['company_name'] ?? '',
                  location: data['location'] ?? '',
                  job_type: data['job_type'] ?? '',
                  salary: data['salary'] ?? '',
                  description: data['description'] ?? '',
                ))
            .toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : jobList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Let's hire your next great candidate.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35.0,
                          ),
                        ),
                        Text(
                          "Fast.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 89, 134)),
                              alignment: Alignment.center,
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/jobpostform');
                            },
                            child: Text("Post a free job*",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                          ),
                        ),
                        Image.asset(
                          'images/working.png',
                          width: 500,
                          height: 350,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: jobList.length,
                  itemBuilder: (context, index) {
                    return JobCard(job: jobList[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/jobpostform');
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future getUserId() async {
    user_id = await UserIdStorage.getUserId() as int;
  }
}

class Job {
  final String title;
  final String company_name;
  final String location;
  final String job_type;
  final String salary;
  final String description;

  Job({
    required this.title,
    required this.company_name,
    required this.location,
    required this.job_type,
    required this.salary,
    required this.description,
  });
}

class JobCard extends StatefulWidget {
  final Job job;

  const JobCard({Key? key, required this.job}) : super(key: key);

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isBooked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        onTap: () => {},
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
                    widget.job.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Company Name: ${widget.job.company_name}'),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.locationDot, size: 14.0),
                      const SizedBox(width: 4.0),
                      Text(widget.job.location),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 227, 225, 216),
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(widget.job.job_type),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 227, 225, 216),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('\u{20B9}${widget.job.salary}'),
                      ),
                    ],
                  ),
                  Text(widget.job.description),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isBooked = !isBooked;
                  });
                },
                icon: FaIcon(
                  isBooked
                      ? FontAwesomeIcons.solidBookmark
                      : FontAwesomeIcons.bookmark,
                  color: isBooked
                      ? const Color.fromARGB(255, 94, 90, 90)
                      : const Color.fromARGB(255, 94, 90, 90),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
