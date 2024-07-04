import 'dart:convert';
import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  final mobile_numberController = TextEditingController();

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
  String mobile_number = '';

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
  String? s_start_month;
  String? s_finish_month;
  String? s_start_year;
  String? s_finish_year;
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
  String c_description = '';
  String? c_start_month;
  String? c_finish_month;
  String? c_start_year;
  String? c_finish_year;

  // Data fields for certification
  final certification_nameController = TextEditingController();
  String Certification_name = '';

  String? yearError;

  final Map<String, List<String>> states = {
    'India': [
      'Andhra Pradesh',
      'Arunachal Pradesh',
      'Assam',
      'Bihar',
      'Chhattisgarh',
      'Delhi',
      'Goa',
      'Gujarat',
      'Haryana',
      'Himachal Pradesh',
      'Jharkhand',
      'Karnataka',
      'Kerala',
      'Madhya Pradesh',
      'Maharashtra',
      'Manipur',
      'Meghalaya',
      'Mizoram',
      'Nagaland',
      'Odisha',
      'Punjab',
      'Rajasthan',
      'Sikkim',
      'Tamil Nadu',
      'Telangana',
      'Tripura',
      'Uttar Pradesh',
      'Uttarakhand',
      'West Bengal'
    ],
  };
  final Map<String, Map<String, List<String>>> cities = {
    'India': {
      'Andhra Pradesh': [
        'Visakhapatnam',
        'Vijayawada',
        'Guntur',
        'Nellore',
        'Kurnool',
        'Rajahmundry',
        'Tirupati'
      ],
      'Arunachal Pradesh': ['Itanagar', 'Tawang', 'Pasighat'],
      'Assam': ['Guwahati', 'Silchar', 'Dibrugarh', 'Jorhat'],
      'Bihar': ['Patna', 'Gaya', 'Bhagalpur', 'Muzaffarpur'],
      'Chhattisgarh': ['Raipur', 'Bhilai', 'Korba', 'Bilaspur'],
      'Delhi': [
        'New Delhi',
        'Old Delhi',
        'Noida',
        'Gurgaon',
        'Faridabad',
        'Ghaziabad',
        'Bahadurgarh',
        'Sonepat'
      ],
      'Goa': ['Panaji', 'Margao', 'Vasco da Gama'],
      'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot'],
      'Haryana': ['Gurugram', 'Faridabad', 'Panipat', 'Ambala'],
      'Himachal Pradesh': ['Shimla', 'Dharamshala', 'Manali'],
      'Jharkhand': ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro'],
      'Karnataka': ['Bengaluru', 'Mysuru', 'Mangaluru', 'Hubballi'],
      'Kerala': ['Thiruvananthapuram', 'Kochi', 'Kozhikode', 'Thrissur'],
      'Madhya Pradesh': ['Bhopal', 'Indore', 'Gwalior', 'Jabalpur'],
      'Maharashtra': [
        'Mumbai',
        'Pune',
        'Nagpur',
        'Nashik',
        'Aurangabad',
        'Solapur'
      ],
      'Manipur': ['Imphal', 'Churachandpur', 'Thoubal'],
      'Meghalaya': ['Shillong', 'Tura', 'Nongpoh'],
      'Mizoram': ['Aizawl', 'Lunglei', 'Champhai'],
      'Nagaland': ['Kohima', 'Dimapur', 'Mokokchung'],
      'Odisha': ['Bhubaneswar', 'Cuttack', 'Rourkela', 'Puri'],
      'Punjab': ['Chandigarh', 'Ludhiana', 'Amritsar', 'Jalandhar'],
      'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota'],
      'Sikkim': ['Gangtok', 'Namchi', 'Geyzing'],
      'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli'],
      'Telangana': ['Hyderabad', 'Warangal', 'Nizamabad', 'Khammam'],
      'Tripura': ['Agartala', 'Udaipur', 'Dharmanagar'],
      'Uttar Pradesh': [
        'Lucknow',
        'Kanpur',
        'Ghaziabad',
        'Agra',
        'Varanasi',
        'Meerut',
        'Prayagraj',
        'Noida'
      ],
      'Uttarakhand': ['Dehradun', 'Haridwar', 'Roorkee'],
      'West Bengal': ['Kolkata', 'Howrah', 'Durgapur', 'Asansol'],
    },
  };

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
                submitForm(),
                Navigator.pushNamed(context, '/profile')
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
              controller: firstnameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => first_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: middlenameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Middle Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => middle_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: lastnameController,
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
              controller: mobile_numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => mobile_number = value,
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
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                  hintText: 'Enter State',
                  border: OutlineInputBorder(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter state name';
                }
                return null;
              },
              suggestionsCallback: (pattern) {
                return states[country]!
                    .where((state) =>
                        state.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                stateController.text = suggestion;
                setState(() {
                  state = suggestion;
                  cityController
                      .clear(); // Clear the city when a new state is selected
                });
              },
              noItemsFoundBuilder: (context) => Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No state found.'),
              ),
            ),
            SizedBox(height: 16),
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  hintText: 'Enter City',
                  border: OutlineInputBorder(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Country name';
                }
                return null;
              },
              suggestionsCallback: (pattern) {
                if (state.isNotEmpty && cities[country]!.containsKey(state)) {
                  return cities[country]![state]!
                      .where((city) =>
                          city.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                } else {
                  return [];
                }
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                cityController.text = suggestion;
                setState(() {
                  city = suggestion;
                });
              },
              noItemsFoundBuilder: (context) => Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No city found.'),
              ),
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
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    List<String> years = List<String>.generate(
        50, (index) => (DateTime.now().year - index).toString());
    void validateYears() {
      setState(() {
        if (s_start_year != null && s_finish_year != null) {
          if (int.parse(s_start_year!) > int.parse(s_finish_year!)) {
            yearError = 'Start year cannot be greater than finish year';
          } else {
            yearError = null;
          }
        } else {
          yearError = null;
        }
      });
    }

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
                hintText: 'Enter state',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => school_state = value,
            ),
            SizedBox(height: 16),
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: school_cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  hintText: 'Enter City',
                  border: OutlineInputBorder(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter City name';
                }
                return null;
              },
              suggestionsCallback: (pattern) {
                if (school_state.isNotEmpty &&
                    cities[country]!.containsKey(school_state)) {
                  return cities[country]![school_state]!
                      .where((city) =>
                          city.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                } else {
                  return [];
                }
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                school_cityController.text = suggestion;
                setState(() {
                  city = suggestion;
                });
              },
              noItemsFoundBuilder: (context) => Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No city found.'),
              ),
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
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Start Month',
                      border: OutlineInputBorder(),
                    ),
                    value: s_start_month,
                    onChanged: (value) =>
                        setState(() => s_start_month = value!),
                    items: months.map((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Finish Month',
                      border: OutlineInputBorder(),
                    ),
                    value: s_finish_month,
                    onChanged: (value) =>
                        setState(() => s_finish_month = value!),
                    items: months.map((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Start Year',
                      border: OutlineInputBorder(),
                    ),
                    value: s_start_year,
                    onChanged: (value) => setState(() {
                      s_start_year = value!;
                      validateYears();
                    }),
                    items: years.map((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Finish Year',
                      border: OutlineInputBorder(),
                    ),
                    value: s_finish_year,
                    onChanged: (value) => setState(() {
                      s_finish_year = value!;
                      validateYears();
                    }),
                    items: years.map((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            if (yearError != null) ...[
              SizedBox(height: 8),
              Text(
                yearError!,
                style: TextStyle(color: Colors.red),
              ),
            ],
            SizedBox(height: 16),
            TextFormField(
              controller: skillController,
              keyboardType: TextInputType.text,
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
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    List<String> years = List<String>.generate(
        50, (index) => (DateTime.now().year - index).toString());
    void validateYears() {
      setState(() {
        if (c_start_year != null && c_finish_year != null) {
          if (int.parse(c_start_year!) > int.parse(c_finish_year!)) {
            yearError = 'Start year cannot be greater than finish year';
          } else {
            yearError = null;
          }
        } else {
          yearError = null;
        }
      });
    }

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
          TypeAheadFormField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: c_cityController,
              decoration: InputDecoration(
                labelText: 'City',
                hintText: 'Enter City',
                border: OutlineInputBorder(),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter City name';
              }
              return null;
            },
            suggestionsCallback: (pattern) {
              if (c_state.isNotEmpty && cities[country]!.containsKey(c_state)) {
                return cities[country]![c_state]!
                    .where((city) =>
                        city.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              } else {
                return [];
              }
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              c_cityController.text = suggestion;
              setState(() {
                city = suggestion;
              });
            },
            noItemsFoundBuilder: (context) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No city found.'),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Start Month',
                    border: OutlineInputBorder(),
                  ),
                  value: c_start_month,
                  onChanged: (value) => setState(() => c_start_month = value!),
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Finish Month',
                    border: OutlineInputBorder(),
                  ),
                  value: c_finish_month,
                  onChanged: (value) => setState(() => c_finish_month = value!),
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Start Year',
                    border: OutlineInputBorder(),
                  ),
                  value: c_start_year,
                  onChanged: (value) => setState(() {
                    c_start_year = value!;
                    validateYears();
                  }),
                  items: years.map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Finish Year',
                    border: OutlineInputBorder(),
                  ),
                  value: c_finish_year,
                  onChanged: (value) => setState(() {
                    s_finish_year = value!;
                    validateYears();
                  }),
                  items: years.map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          if (yearError != null) ...[
            SizedBox(height: 8),
            Text(
              yearError!,
              style: TextStyle(color: Colors.red),
            ),
          ],
          SizedBox(height: 16),
          TextFormField(
            controller: j_descriptionController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Job Description',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => c_description = value,
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

  void submitForm() async {
    try {
      await getUserId();
      final userData = {
        'first_name': firstnameController.text,
        'middle_name': middlenameController.text,
        'last_name': lastnameController.text,
        'dob': dobController.text,
        'gender': genderController.text,
        'Mobile Number': mobile_numberController,
        'street': streetController.text,
        'pincode': pincodeController.text,
        'city': cityController.text,
        'state': stateController.text,
        'country': countryController.text,
      };

      final educationData = {
        'education_level_name': education_level_nameController.text,
        'study_field': study_fieldController.text,
        'school_name': school_nameController.text,
        'school_state': school_stateController.text,
        'school_city': school_cityController.text,
        'grade': gradeController.text,
        's_start_month': s_start_monthController.text,
        's_finish_month': s_finish_monthController.text,
        's_start_year': s_start_yearController.text,
        's_finish_year': s_finish_yearController.text,
        'skill': skillController.text,
      };

      final experienceData = {
        'company_name': company_nameController.text,
        'c_state': c_stateController.text,
        'c_city': c_cityController.text,
        'j_description': j_descriptionController.text,
        'j_start_month': j_start_monthController.text,
        'j_finish_month': j_finish_monthController.text,
        'j_start_year': j_start_yearController.text,
        'j_finish_year': j_finish_yearController.text,
      };

      final certificationData = {
        'certification_name': certification_nameController.text,
      };

      final url = Platform.isAndroid
          ? 'http://10.0.3.2:8000/api/dashboard'
          : 'http://localhost:8000/api/dashboard';
      final response = await Future.wait([
        http.put(
          Uri.parse('$url/user/updateUserDetails/$user_id'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(userData),
        ),
        http.post(
          Uri.parse('$url/resume/InsertEducation/$user_id'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(educationData),
        ),
        http.post(
          Uri.parse('$url/resume/InsertEducation/$user_id'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(experienceData),
        ),
        http.post(
          Uri.parse('$url/resume/InsertCertification/$user_id'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(certificationData),
        ),
      ]);
      bool success = response.every((response) =>
          response.statusCode == 200 || response.statusCode == 201);
      if (success) {
        CommonHelper.animatedSnackBar(context, 'Data submitted successfully',
            AnimatedSnackBarType.success);
      } else {
        CommonHelper.animatedSnackBar(
            context, 'Failed to submit data', AnimatedSnackBarType.error);
      }
    } catch (e) {
      print('Error: $e');
      CommonHelper.animatedSnackBar(
          context, 'Failed to connect', AnimatedSnackBarType.error);
    }
  }
}
