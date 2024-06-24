import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/helper/commonhelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildResume extends StatefulWidget {
  @override
  _BuildResumeState createState() => _BuildResumeState();
}

class _BuildResumeState extends State<BuildResume> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int user_id = 0;

  Future getUserId() async {
    user_id = await UserIdStorage.getUserId() as int;
  }

  final firstnameController = TextEditingController();
  final middlenameController = TextEditingController();
  final lastnameController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final pincodeController = TextEditingController();

  // Data fields for users
  String first_name = '';
  String middle_name = '';
  String last_name = '';
  DateTime? dob;
  String? gender;
  String street = '';
  String city = '';
  String state = '';
  String country = 'India';
  String pincode = '';

  // Data fields for education
  final education_level_nameController = TextEditingController();
  final study_fieldController = TextEditingController();
  final school_nameController = TextEditingController();
  final school_stateController = TextEditingController();
  final school_cityController = TextEditingController();
  final s_start_monthController = TextEditingController();
  final s_start_yearController = TextEditingController();
  final s_finish_monthController = TextEditingController();
  final s_finish_yearController = TextEditingController();
  final skillController = TextEditingController();
  final gradeController = TextEditingController();

  String education_level_name = '';
  String study_field = '';
  String school_name = '';
  String school_state = '';
  String school_city = '';
  String grade = '';
  String s_start_month = '';
  String s_finish_month = '';
  String s_start_year = '';
  String s_finish_year = '';
  String skill = '';

  // Data fields for experience
  final company_nameController = TextEditingController();
  final c_stateController = TextEditingController();
  final c_cityController = TextEditingController();
  final j_descriptionController = TextEditingController();
  final j_start_monthController = TextEditingController();
  final j_start_yearController = TextEditingController();
  final j_finish_monthController = TextEditingController();
  final j_finish_yearController = TextEditingController();

  String company_name = '';
  String c_state = '';
  String c_city = '';
  String j_description = '';
  String j_start_month = '';
  String j_finish_month = '';
  String j_start_year = '';
  String j_finish_year = '';

  // Data fields for certification
  final certification_nameController = TextEditingController();
  String Certification_name = '';

  void nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume Creation'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
          padding: EdgeInsets.all(16),
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildUserDetailsPage(),
              _buildEducationDetailsPage(),
              _buildJobExperiencePage(),
              _buildQualificationsPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (_currentPage != 0)
            ElevatedButton(
              onPressed: previousPage,
              child: Text('Previous'),
            ),
          if (_currentPage != 3)
            ElevatedButton(
              onPressed: nextPage,
              child: Text('Next'),
            ),
          if (_currentPage == 3)
            ElevatedButton(
              onPressed: () => {
                Navigator.pushNamed(context, '/reviewresume')
              }, //_submitForm,
              child: Text('Review'),
            ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != dob) {
      setState(() {
        dob = pickedDate;
      });
    }
  }

  Widget _buildUserDetailsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Details', style: TextStyle(fontSize: 20)),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => first_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: firstnameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Middle Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => middle_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: middlenameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => last_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectDate(context),
              readOnly: true,
              controller: TextEditingController(
                text: dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : '',
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              value: gender,
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
              items: ['Male', 'Female', 'Others'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: countryController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  country = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Country name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: stateController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => country = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: cityController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => country = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: streetController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelText: 'Street',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => street = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: pincodeController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Pincode',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => pincode = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationDetailsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Education Details', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            TextFormField(
              controller: education_level_nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Education Level Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => education_level_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: study_fieldController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Study Field',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => study_field = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: school_nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'School Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => school_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: school_stateController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'School State',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => school_state = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: school_cityController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'School City',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => school_city = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: gradeController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Grade',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => grade = value,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: s_start_monthController,
                    decoration: InputDecoration(
                      labelText: 'Start Month',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => s_start_month = value,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Finish Month',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => s_finish_month = value,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Start Year',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => s_start_year = value,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Finish Year',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => s_finish_year = value,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Skill',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => skill = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobExperiencePage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Job Experience', style: TextStyle(fontSize: 20)),
          SizedBox(height: 16),
          TextFormField(
            controller: company_nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'Company Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => company_name = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: c_stateController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'State',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => c_state = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: c_cityController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => c_city = value,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Start Month',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => j_start_month = value,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Finish Month',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => j_finish_month = value,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Start Year',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => j_start_year = value,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Finish Year',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => j_finish_year = value,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: j_descriptionController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Job Description',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => j_description = value,
          ),
        ],
      ),
    );
  }

  Widget _buildQualificationsPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Certification', style: TextStyle(fontSize: 20)),
          TextFormField(
            controller: certification_nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Certification', border: OutlineInputBorder()),
            onChanged: (value) => Certification_name = value,
          ),
          SizedBox(
            height: 16.0,
          ),
          ElevatedButton(onPressed: () => {}, child: Text('Add'))
        ],
      ),
    );
  }

  void _submitForm() async {
    try {
      await getUserId();
      final first_name = firstnameController;
      final middle_name = middlenameController;
      final last_name = lastnameController;
      final dob = dobController;
      final country = countryController;
      final state = stateController;
      final city = cityController;
      final street = streetController;
      final pincode = pincodeController;

      final education_level = education_level_nameController;
      final study_field = study_fieldController;
      final school_name = school_nameController;
      final school_state = school_stateController;
      final school_city = school_cityController;
      final skill = skillController;
      final grade = gradeController;

      final company_name = company_nameController;
      final c_state = c_stateController;
      final c_city = c_cityController;
      final j_description = j_descriptionController;

      final certification_name = certification_nameController;

      final url = Platform.isAndroid
          ? 'http://10.0.3.2:8000/api/dashboard/job/insert/$user_id'
          : 'http://localhost:8000/api/dashboard/job/insert/$user_id';

      final response = await http.post(Uri.parse(url),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'First Name': first_name,
            'Middle Name': middle_name,
            'Last_Name': last_name,
            'Date of Birth': dob,
            'gender': gender,
            'Street': street,
            'Pin Code':pincode,
            'City':city,
            'State':state,
            'Country':country,
          }));
    } catch (e) {
      print('Error: $e');
      CommonHelper.animatedSnackBar(
          context, 'Failed to connect', AnimatedSnackBarType.error);
    }
  }
}
