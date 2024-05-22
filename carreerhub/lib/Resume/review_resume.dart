import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewResume extends StatefulWidget {
  @override
  _ReviewResumeState createState() => _ReviewResumeState();
}

class _ReviewResumeState extends State<ReviewResume> {
  // Data fields for user details
  String first_name = 'John';
  String middle_name = 'A';
  String last_name = 'Doe';
  DateTime? dob = DateTime(1990, 1, 1);
  String? gender = 'Male';
  String street = '123 Main St';
  String state = 'California';
  String country = 'USA';
  String pincode = '90001';

  // Data fields for education
  String education_level_name = 'Bachelor';
  String study_field = 'Computer Science';
  String school_name = 'ABC University';
  String school_state = 'California';
  String school_city = 'Los Angeles';
  String grade = 'A';
  String start_month = 'January';
  String finish_month = 'December';
  String start_year = '2010';
  String finish_year = '2014';
  String certification_name = 'Flutter Development';

  // Data fields for experience
  String company_name = 'XYZ Corp';
  String c_state = 'California';
  String c_city = 'San Francisco';
  String j_description = 'Software Developer';
  String j_start_month = 'January';
  String j_finish_month = 'December';
  String j_start_year = '2015';
  String j_finish_year = '2020';

  // Data field for qualifications
  String skill = 'Programming';

  void _submitForm() {
    // Logic to handle form submission
    print('Form submitted');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Resume'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Details', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                initialValue: first_name,
                onChanged: (value) => first_name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Middle Name',
                  border: OutlineInputBorder(),
                ),
                initialValue: middle_name,
                onChanged: (value) => middle_name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                initialValue: last_name,
                onChanged: (value) => last_name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                readOnly: true,
                controller: TextEditingController(
                  text:
                      dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : '',
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
                    gender = value;
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
                initialValue: street,
                onChanged: (value) => street = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                initialValue: state,
                onChanged: (value) => state = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
                initialValue: country,
                onChanged: (value) => country = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pincode',
                  border: OutlineInputBorder(),
                ),
                initialValue: pincode,
                onChanged: (value) => pincode = value,
              ),
              SizedBox(height: 32),
              Text('Education Details', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Education Level',
                  border: OutlineInputBorder(),
                ),
                initialValue: education_level_name,
                onChanged: (value) => education_level_name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Field of Study',
                  border: OutlineInputBorder(),
                ),
                initialValue: study_field,
                onChanged: (value) => study_field = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'School Name',
                  border: OutlineInputBorder(),
                ),
                initialValue: school_name,
                onChanged: (value) => school_name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'School State',
                  border: OutlineInputBorder(),
                ),
                initialValue: school_state,
                onChanged: (value) => school_state = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'School City',
                  border: OutlineInputBorder(),
                ),
                initialValue: school_city,
                onChanged: (value) => school_city = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Grade',
                  border: OutlineInputBorder(),
                ),
                initialValue: grade,
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
                      initialValue: start_month,
                      onChanged: (value) => start_month = value,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Finish Month',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: finish_month,
                      onChanged: (value) => finish_month = value,
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
                      initialValue: start_year,
                      onChanged: (value) => start_year = value,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Finish Year',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: finish_year,
                      onChanged: (value) => finish_year = value,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Certification Name',
                  border: OutlineInputBorder(),
                ),
                initialValue: certification_name,
                onChanged: (value) => certification_name = value,
              ),
              SizedBox(height: 32),
              Text('Job Experience', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                initialValue: company_name,
                onChanged: (value) => company_name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Company State',
                  border: OutlineInputBorder(),
                ),
                initialValue: c_state,
                onChanged: (value) => c_state = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Company City',
                  border: OutlineInputBorder(),
                ),
                initialValue: c_city,
                onChanged: (value) => c_city = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Job Description',
                  border: OutlineInputBorder(),
                ),
                initialValue: j_description,
                onChanged: (value) => j_description = value,
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
                      initialValue: j_start_month,
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
                      initialValue: j_finish_month,
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
                      initialValue: j_start_year,
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
                      initialValue: j_finish_year,
                      onChanged: (value) => j_finish_year = value,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text('Certification', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Skills',
                  border: OutlineInputBorder(),
                ),
                initialValue: skill,
                onChanged: (value) => skill = value,
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
