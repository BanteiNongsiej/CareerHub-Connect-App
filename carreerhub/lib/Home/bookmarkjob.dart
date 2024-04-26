import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobBookmarkScreen extends StatefulWidget {
  const JobBookmarkScreen({Key? key}) : super(key: key);

  @override
  _JobBookmarkScreenState createState() => _JobBookmarkScreenState();
}

class _JobBookmarkScreenState extends State<JobBookmarkScreen> {
  List<Map<String, dynamic>> bookmarkedJobs = [];

  @override
  void initState() {
    super.initState();
    // Load bookmarked jobs when the screen initializes
    loadBookmarkedJobs();
  }

  Future<void> loadBookmarkedJobs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? bookmarkedJobKeys = prefs.getKeys().toList();

  if (bookmarkedJobKeys != null) {
    setState(() {
      bookmarkedJobs.clear();
      for (String key in bookmarkedJobKeys) {
        final String? encodedJob = prefs.getString(key);
        if (encodedJob != null) {
          final Map<String, dynamic> decodedJob = jsonDecode(encodedJob);
          bookmarkedJobs.add(decodedJob);
        }
      }
      print('Bookmarked jobs loaded: $bookmarkedJobs');
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Jobs'),
      ),
      body: bookmarkedJobs.isEmpty
          ? Center(
              child: Text('No bookmarked jobs'),
            )
          : ListView.builder(
              itemCount: bookmarkedJobs.length,
              itemBuilder: (context, index) {
                return BookmarkJobCard(jobData: bookmarkedJobs[index]);
              },
            ),
    );
  }
}

class BookmarkJobCard extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const BookmarkJobCard({Key? key, required this.jobData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 240, 245, 248),
      shadowColor: Color.fromARGB(255, 215, 50, 9),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        onTap: () {
          // Handle onTap for bookmarked job card if needed
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
                    jobData['title'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(jobData['company_name'] ?? ''),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.locationDot, size: 14.0),
                      const SizedBox(width: 4.0),
                      Text(jobData['location'] ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 227, 225, 216),
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(jobData['job_type'] ?? ''),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 227, 225, 216),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('\u{20B9}${jobData['salary'] ?? ''}'),
                      ),
                    ],
                  ),
                  Text(
                    jobData['description'] ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  // Handle unbookmarking action if needed
                },
                icon: FaIcon(
                  FontAwesomeIcons.solidBookmark,
                  color: const Color.fromARGB(255, 94, 90, 90),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
