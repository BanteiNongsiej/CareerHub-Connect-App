import 'dart:convert';
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:carreerhub/helper/commonhelper.dart';
import 'package:http/http.dart' as http;
import 'package:carreerhub/model/jobModel.dart';
import 'package:flutter/material.dart';
import 'package:carreerhub/GetuserId.dart';

class JobPostFormScreen extends StatefulWidget {
  const JobPostFormScreen({super.key});

  @override
  State<JobPostFormScreen> createState() => _JobPostScreenFormState();
}

class _JobPostScreenFormState extends State<JobPostFormScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int user_id = 0;
  final _titleController = TextEditingController();
  final _companynameController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();
  final _jobtypeController = TextEditingController();
  final _descriptionController = TextEditingController();

  String title = "";
  String company_name = "";
  String salary = "";
  String location = "";
  String job_type = "";
  String description = "";

  Future getUserId() async {
    user_id = await UserIdStorage.getUserId() as int;
  }

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
        //automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                      controller: _titleController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Job title is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _companynameController,
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
                      controller: _salaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Salary',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _locationController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _jobtypeController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Job Type',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
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
                              () {
                                post();
                              },
                            );
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
    await getUserId();
    if (formKey.currentState!.validate()) {
      final title = _titleController.text;
      final company_name = _companynameController.text;
      final salary = _salaryController.text;
      final location = _locationController.text;
      final job_type = _jobtypeController.text;
      final description = _descriptionController.text;
      formKey.currentState!.save();
      String url = '';
      if (Platform.isAndroid) {
        url = 'http://10.0.3.2:8000/api/dashboard/job/insert/$user_id';
      } else {
        url = 'http://localhost:8000/api/dashboard/job/insert/$user_id';
      }
      try {
        var response = await http.post(Uri.parse(url), body: {
          'title': title,
          'company_name': company_name,
          'salary': salary,
          'location': location,
          'job_type': job_type,
          'description': description
        }, headers: {
          'Accept': 'application/json',
          // 'Content-Type': 'application/json'
        });
        var data = jsonDecode(response.body);
        print(response);
        if ((response.statusCode == 200)) {
          CommonHelper.animatedSnackBar(
              context, data['message'], AnimatedSnackBarType.success);
          Navigator.pushNamed(context, '/dashboard');
        } else if (response.statusCode == 404) {
          CommonHelper.animatedSnackBar(
              context, data['message'], AnimatedSnackBarType.error);
        }
      } catch (e) {
        print('$e');
      }
    }
  }
}
