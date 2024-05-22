import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<Map<String, dynamic>> dataList = []; // List to store data
  List<Job> jobList = [];
  List<Job> filteredJobList = []; // List to store filtered data
  bool isloading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Simulating isLoading time with a delay of 3 seconds
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
                  name: data['name'] ?? '',
                  address: data['address'] ?? '',
                  job_type: data['job_type'] ?? '',
                  min_salary: data['min_salary'] ?? '',
                  description: data['description'] ?? '',
                ))
            .toList();
        filteredJobList =
            List.from(jobList); // Initialize filteredJobList with jobList
        isloading = false;
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  void filterJobs(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        // If keyword is empty, display all jobs
        filteredJobList = List.from(jobList);
      } else {
        // Filter jobs based on keyword
        filteredJobList = jobList
            .where((job) =>
                job.title.toLowerCase().contains(keyword.toLowerCase()) ||
                job.name
                    .toLowerCase()
                    .contains(keyword.toLowerCase()) ||
                job.address.toLowerCase().contains(keyword.toLowerCase()) ||
                job.job_type.toLowerCase().contains(keyword.toLowerCase()) ||
                job.min_salary.toLowerCase().contains(keyword.toLowerCase()) ||
                job.description.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0), // Add padding here
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Set border radius here
                borderSide: BorderSide.none, // Hide the border
              ),
              hintStyle: TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  filterJobs(searchController
                      .text); // Call filterJobs function on search button press
                },
              ),
            ),
            onChanged: (value) {
              filterJobs(value); // Call filterJobs function on text change
            },
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 248, 246, 242),
      body: Skeletonizer(
        enabled: isloading,
        child: isloading
            ? ListView.builder(
                itemCount: 6, // Placeholder for 5 items
                itemBuilder: (context, index) {
                  return JobCardPlaceholder(); // Placeholder widget for job card
                },
              )
            : filteredJobList.isEmpty
                ? Center(
                    child: Text('No jobs available'),
                  )
                : ListView.builder(
                    itemCount: filteredJobList.length,
                    itemBuilder: (context, index) {
                      return JobCard(job: filteredJobList[index]);
                    },
                  ),
      ),
    );
  }
}

class Job {
  final String title;
  final String name;
  final String address;
  final String job_type;
  final String min_salary;
  final String description;

  Job({
    required this.title,
    required this.name,
    required this.address,
    required this.job_type,
    required this.min_salary,
    required this.description,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      job_type: json['job_type'] ?? '',
      min_salary: json['min_salary'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'name': name,
      'address': address,
      'job_type': job_type,
      'min_salary': min_salary,
      'description': description,
    };
  }
}

class JobCard extends StatefulWidget {
  final Job job;

  const JobCard({Key? key, required this.job}) : super(key: key);

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isBooked = false;

  String generateJobKey(Job job) {
    return "bookmarked_job_${job.title}_${job.name}";
  }

  @override
  Widget build(BuildContext context) {
  return Card(
    color: Color.fromARGB(255, 240, 245, 248),
    shadowColor: Color.fromARGB(255, 215, 50, 9),
    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      onTap: () => {
        Navigator.pushNamed(context, '/jobdetails')
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
                    Container(
                      color: const Color.fromARGB(255, 227, 225, 216),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('\u{20B9}${widget.job.min_salary}'),
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
                checkBookmark();
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


  void checkBookmark() {
    setState(() {
      isBooked = !isBooked;
      if (isBooked) {
        Bookmark(widget.job);
      } else {
        unBookmark(widget.job);
      }
    });
  }

  Future<void> Bookmark(Job job) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedJob = jsonEncode(job.toJson());
    // Use a key that combines a prefix and job title for better organization
    final String key = generateJobKey(job);
    await prefs.setString(key, encodedJob);
    //print(Bookmark(job.title));
  }

  Future<void> unBookmark(Job job) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = generateJobKey(job);
    await prefs.remove(key);
  }
}

class JobCardPlaceholder extends StatefulWidget {
  @override
  State<JobCardPlaceholder> createState() => _JobCardPlaceholderState();
}

class _JobCardPlaceholderState extends State<JobCardPlaceholder> {
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
