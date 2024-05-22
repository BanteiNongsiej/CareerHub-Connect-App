import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildResume extends StatefulWidget {
  @override
  _BuildResumeState createState() => _BuildResumeState();
}

class _BuildResumeState extends State<BuildResume> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // Data fields for users
  String first_name = '';
  String middle_name = '';
  String last_name = '';
  DateTime? dob;
  String? gender;
  String street = '';
  String state = '';
  String country = '';
  String pincode = '';

  // Data fields for education
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
  String company_name = '';
  String c_state = '';
  String c_city = '';
  String j_description = '';
  String j_start_month = '';
  String j_finish_month = '';
  String j_start_year = '';
  String j_finish_year = '';

  // Data fields for certification
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
              onPressed: ()=>{Navigator.pushNamed(context, '/reviewresume')},//_submitForm,
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
              decoration: InputDecoration(
                labelText: 'Middle Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => middle_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
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
              decoration: InputDecoration(
                labelText: 'Street',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => street = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => state = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => country = value,
            ),
            SizedBox(height: 16),
            TextFormField(
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
              decoration: InputDecoration(
                labelText: 'Education Level Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => education_level_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Study Field',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => study_field = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'School Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => school_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'School State',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => school_state = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'School City',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => school_city = value,
            ),
            SizedBox(height: 16),
            TextFormField(
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
          decoration: InputDecoration(
            labelText: 'Company Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => company_name = value,
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'State',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => c_state = value,
        ),
        SizedBox(height: 16),
        TextFormField(
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
            decoration: InputDecoration(labelText: 'Certification',border: OutlineInputBorder()),
            onChanged: (value) => Certification_name = value,
          ),
          SizedBox(height: 16.0,),
          ElevatedButton(onPressed: ()=>{}, child:Text('Add'))
        ],
      ),
    );
  }

  void _submitForm() {
    // Store data to database or perform any other action
    //print('User Name: $userName');
    //print('Address: $userAddress');
    //print('Education Details: $educationDetails');
    //print('Job Experience: $jobExperience');
    //print('Qualifications: $qualifications');

    // You can add code here to store the data to your database
  }
}
