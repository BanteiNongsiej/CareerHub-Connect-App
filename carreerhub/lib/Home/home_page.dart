import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<Map<String, dynamic>> dataList = []; // List to store data
  List<Job> jobList = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    // Simulating isloading time with a delay of 3 seconds
    Future.delayed(Duration(seconds: 2), () {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('http://10.0.3.2:8000/api/dashboard/job/showalljob'));
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
        isloading = false;
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 246, 242),
      body: Skeletonizer(
        enabled:isloading,
        child: isloading
            ? ListView.builder(
                itemCount: 6, // Placeholder for 5 items
                itemBuilder: (context, index) {
                  return JobCardPlaceholder(); // Placeholder widget for job card
                },
              )
            : jobList.isEmpty
                ? Center(
                    child: Text('No jobs available'),
                  )
                : ListView.builder(
                    itemCount: jobList.length,
                    itemBuilder: (context, index) {
                      return JobCard(job: jobList[index]);
                    },
                  ),
      ),
    );
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
      color: Color.fromARGB(255, 240, 245, 248),
      shadowColor: Color.fromARGB(255, 215, 50, 9),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                      ),
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
                  Text( 
                    widget.job.description,
                    overflow: TextOverflow.ellipsis,
                  ),
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
class JobCardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.grey[300], // Placeholder color
            ),
            SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 10.0,
              color: Colors.grey[300], // Placeholder color
            ),
            SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 10.0,
              color: Colors.grey[300], // Placeholder color
            ),
            SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 10.0,
              color: Colors.grey[300], // Placeholder color
            ),
          ],
        ),
      ),
    );
  }
}

