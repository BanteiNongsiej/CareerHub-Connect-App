import 'package:flutter/material.dart';

class JobDetails extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String address;
  final String jobType;
  final String schedule;
  final String minimumSalary;
  final String maximumSalary;
  final String rate;
  final String numberOfPeople;
  final String yearsOfExperience;
  final String qualifications;
  final String skills;
  final String jobDescription;

  JobDetails({
    this.jobTitle = 'Job Title',
    this.companyName = 'Company Name',
    this.address = '123, Street Name, City, State, Country - 123456',
    this.jobType = 'Full-time',
    this.schedule = 'Day Shift',
    this.minimumSalary = '1000',
    this.maximumSalary = '2000',
    this.rate = 'Per Month',
    this.numberOfPeople = '5',
    this.yearsOfExperience = '2',
    this.qualifications = 'Bachelor\'s Degree',
    this.skills = 'Skill 1, Skill 2, Skill 3',
    this.jobDescription = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Title: $jobTitle',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Company Name: $companyName',
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 8),
            Text(
              'Address: $address',
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 8),
            Text(
              'Job Type: $jobType',
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 8),
            Text(
              'Schedule: $schedule',
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 8),
            Text(
              'Salary Range: $minimumSalary - $maximumSalary $rate',
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 8),
            Text(
              'Number of People: $numberOfPeople',
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 8),
            Text(
              'Years of Experience: $yearsOfExperience',
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 8),
            Text(
              'Qualifications Required: $qualifications',
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 8),
            Text(
              'Skills Required: $skills',
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 8),
            Text(
              'Job Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              jobDescription,
              style: TextStyle(fontSize: 15,),
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
      ),
    );
  }
}
