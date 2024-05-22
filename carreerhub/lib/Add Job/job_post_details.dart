import 'package:flutter/material.dart';

class JobPostDetails extends StatefulWidget {
  @override
  _JobPostDetailsState createState() => _JobPostDetailsState();
}

class _JobPostDetailsState extends State<JobPostDetails> {
  final formKey = GlobalKey<FormState>();
  String job_type = 'Select an option'; // Default value
  String schedule = 'Select an option'; // Default value
  int? no_of_people;
  String? yearsOfExperience;
  String? qualifications;
  String? skills;
  String? jobDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Job Details',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Image.asset(
                  'images/working.png',
                  width: double.infinity,
                  height: 150,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: job_type,
                  decoration: InputDecoration(
                    labelText: 'Job Type *',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Select an option',
                    'Full-time',
                    'Permanent',
                    'Part-time',
                    'Temporary'
                  ].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      job_type = value!;
                    });
                  },
                  validator: (value) {
                    if (value == 'Select an option') {
                      return 'Please select a job type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: schedule,
                  decoration: InputDecoration(
                    labelText: 'Schedule *',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Select an option',
                    'Day Shift',
                    'Night Shift',
                    'Evening Shift'
                  ].map((schedule) {
                    return DropdownMenuItem<String>(
                      value: schedule,
                      child: Text(schedule),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      schedule = value!;
                    });
                  },
                  validator: (value) {
                    if (value == 'Select an option') {
                      return 'Please select a schedule';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of People to Hire *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of people to hire';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    no_of_people = int.tryParse(value!);
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of Years of Experience',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    yearsOfExperience = value;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Qualifications Required',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    qualifications = value;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Skills Required',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    skills = value;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Job Description',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    jobDescription = value;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            Navigator.pushNamed(context, '/jobpostsalary');
                          }
                        },
                        child: Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
