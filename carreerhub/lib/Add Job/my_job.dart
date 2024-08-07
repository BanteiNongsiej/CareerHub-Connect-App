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
                id: data['id'] ?? '',
                title: data['title'] ?? '',
                name: data['name'] ?? '',
                address: data['address'] ?? '',
                job_type: data['job_type'] ?? '',
                min_salary: data['min_salary'] ?? '',
                max_salary: data['max_salary'] ?? '',
                description: data['description'] ?? '',
                shift_type: data['shift_type'] ?? ''))
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 34, 89, 134)),
                              alignment: Alignment.center,
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/jobpost');
                            },
                            child: Text(
                              "Post a free job*",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
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
          Navigator.pushNamed(context, '/jobpost');
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
  final int id;
  final String title;
  final String name;
  final String address;
  final String job_type;
  final String min_salary;
  final String max_salary;
  final String description;
  final String shift_type;

  Job({
    required this.id,
    required this.title,
    required this.name,
    required this.address,
    required this.job_type,
    required this.min_salary,
    required this.max_salary,
    required this.description,
    required this.shift_type,
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
        onTap: () => {
          Navigator.pushNamed(context, '/job_application',
              arguments: widget.job.id)
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
                    widget.job.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(widget.job.name),
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
                          widget.job.address,
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
                        child: Text(widget.job.job_type),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 227, 225, 216),
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(widget.job.shift_type),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 227, 225, 216),
                        //padding: EdgeInsets.symmetric(horizontal: 20),
                        child: widget.job.max_salary.isEmpty
                            ? Text('\u{20B9}${widget.job.min_salary}')
                            : Text(
                                '\u{20B9}${widget.job.min_salary} - \u{20B9}${widget.job.max_salary}'),
                      ),
                    ],
                  ),
                  Text(
                    widget.job.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              // IconButton(
              //   onPressed: () {
              //    // deleteJob();
              //   },
              //   icon: FaIcon(
              //     FontAwesomeIcons.trash,
              //     color: const Color.fromARGB(255, 94, 90, 90),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
