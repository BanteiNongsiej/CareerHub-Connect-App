import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:carreerhub/model/jobModel.dart';
import 'package:flutter/material.dart';

class JobPostFormScreen extends StatefulWidget {
  const JobPostFormScreen({super.key});

  @override
  State<JobPostFormScreen> createState() => _JobPostScreenFormState();
}

class _JobPostScreenFormState extends State<JobPostFormScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  // JobModel job = JobModel(
  //     id: id,
  //     title: title,
  //     salary: salary,
  //     location: location,
  //     job_type: job_type,
  //     description: description);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 142, 233, 237),
        title: const Text(
          "Add Job",
          style: TextStyle(
              color: Color.fromARGB(255, 8, 30, 228),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 20
              //fontFamily:AutofillHints.countryName
              ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  //border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty || value == null) {
                          return 'Job title is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Salary',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty || value == null) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty || value == null) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Job Type',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty || value == null) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty || value == null) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            Future.delayed(
                              const Duration(seconds: 3),
                              () {},
                            );
                            post();
                          },
                          child: isLoading == true
                              ? const CircularProgressIndicator()
                              : const Text('Post'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //cancel();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void post() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String url = '';
      if (Platform.isAndroid) {
        url = 'http://10.0.3.2:8000/api/dashboard/job/insert';
      } else {
        url = 'http://localhost:8000/api/dashboard/job/insert';
      }
    }
  }
}
