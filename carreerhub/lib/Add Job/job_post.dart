import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/helper/commonhelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class JobPost extends StatefulWidget {
  @override
  _JobPostState createState() => _JobPostState();
}

class _JobPostState extends State<JobPost> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final formKey = GlobalKey<FormState>();
  int user_id = 0;
  String? selectedPaymentMethod = 'Range';

  Future getUserId() async {
    user_id = await UserIdStorage.getUserId() as int;
  }

  final job_titleController = TextEditingController();
  final company_nameControlller = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final pincodeController = TextEditingController();
  final job_typeController = TextEditingController();
  final shift_typeController = TextEditingController();
  final no_peopleController = TextEditingController();
  final experience_reqController = TextEditingController();
  final qualification_reqController = TextEditingController();
  //final skillController = TextEditingController();
  final descriptionController = TextEditingController();
  final min_salaryController = TextEditingController();
  final max_salaryController = TextEditingController();
  final salary_periodController = TextEditingController();

  // Data fields for users
  String job_title = '';
  String company_name = '';
  String city = '';
  String street = '';
  String state = '';
  String country = 'India';
  String pincode = '';
  String min_salary = '';
  String max_salary = '';
  String salary_period = 'Per Month';
  String job_type = 'Full-time';
  String shift_type = 'Day';
  String no_people = '';
  String experience_req = '';
  String qualification_req = '';
  String description = '';
  //String skill = '';

  final Map<String, List<String>> states = {
    'India': [
      'Andhra Pradesh',
      'Arunachal Pradesh',
      'Assam',
      'Bihar',
      'Chhattisgarh',
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

  @override
  void initState() {
    super.initState();
    getUserId();
  }

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
        title: Text('Job Posting'),
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
              JobBasicsDetails(),
              JobDetailsPage(),
              SalaryDetailsPage(),
              ReviewJobDetailsPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (_currentPage == 0)
            ElevatedButton(
              onPressed: nextPage,
              child: Text('Next'),
            ),
          if (_currentPage == 1)
            Row(
              children: [
                ElevatedButton(
                  onPressed: previousPage,
                  child: Text('Previous'),
                ),
                SizedBox(width: 82),
                ElevatedButton(
                  onPressed: nextPage,
                  child: Text('Next'),
                ),
              ],
            ),
          if (_currentPage == 2)
            ElevatedButton(
              onPressed: previousPage,
              child: Text('Previous'),
            ),
          if (_currentPage == 2)
            ElevatedButton(
              onPressed: nextPage,
              child: Text('Review'),
            ),
          if (_currentPage == 3)
            Row(
              children: [
                ElevatedButton(
                  onPressed: previousPage,
                  child: Text('Edit Job Details'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    popupdialog(context);
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget JobBasicsDetails() {
    countryController.text = country;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Job Basics Detail',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Image.asset(
              'images/job_basics.png',
              width: double.infinity,
              height: 200,
            ),
            TextFormField(
              controller: job_titleController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Job Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  job_title = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Job title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
                controller: company_nameControlller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    company_name = value;
                  });
                }),
            SizedBox(height: 16),
            TextFormField(
              controller: countryController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
              //initialValue: 'India',
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
                  return 'Please enter Country name';
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
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Street',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  street = value;
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
              controller: pincodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Pincode',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  pincode = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Country name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget JobDetailsPage() {
    job_type = 'Full-time';
    shift_type = 'Day';
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'images/working.png',
              width: double.infinity,
              height: 175,
            ),
            SizedBox(
              height: 16,
            ),
            DropdownButtonFormField<String>(
              value: job_type,
              decoration: InputDecoration(
                labelText: 'Job Type *',
                border: OutlineInputBorder(),
              ),

              items: [
                'Full-time',
                'Permanent',
                'Part-time',
                'Temporary',
                'Internship'
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
              // validator: (value) {
              //   if (value == 'Select an option') {
              //     return 'Please select a job type';
              //   }
              //   return null;
              // },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: shift_type,
              decoration: InputDecoration(
                labelText: 'Shift Type *',
                border: OutlineInputBorder(),
              ),
              items: ['Day', 'Night', 'Morning'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  shift_type = value!;
                });
              },
              // validator: (value) {
              //   if (value == 'Select an option') {
              //     return 'Please select a shift type';
              //   }
              //   return null;
              // },
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: no_peopleController,
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
              onChanged: (value) {
                setState(() {
                  no_people = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: experience_reqController,
              decoration: InputDecoration(
                labelText: 'Number of Years of Experience',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  experience_req = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: qualification_reqController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Qualifications Required',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  qualification_req = value;
                });
              },
            ),
            SizedBox(height: 16),
            // TextFormField(
            //   controller: skillController,
            //   keyboardType: TextInputType.name,
            //   decoration: InputDecoration(
            //     labelText: 'Skills Required',
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: (value) {
            //     setState(() {
            //       skill = value;
            //     });
            //   },
            // ),
            // SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Job Description',
                border: OutlineInputBorder(),
              ),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter Country name';
              //   }
              //   return null;
              // },
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget SalaryDetailsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add Salary details',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Image.asset(
                'images/job_salary.png',
                width: double.infinity,
                height: 150,
              ),
              Text(
                'Show Pay By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
                items: ['Range', 'Exact Amount']
                    .map((method) => DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              if (selectedPaymentMethod == 'Range') ...[
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Minimum Salary',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the minimum salary';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    min_salary = value;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: min_salaryController,
                  decoration: InputDecoration(
                    labelText: 'Maximum Salary',
                    border: OutlineInputBorder(),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter the maximum salary';
                  //   }
                  //   return null;
                  // },
                  onChanged: (value) {
                    max_salary = value;
                  },
                ),
              ],
              if (selectedPaymentMethod == 'Exact Amount')
                TextFormField(
                  controller: min_salaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Salary',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the salary';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    min_salary = value;
                    max_salary = value;
                  },
                ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: salary_period,
                decoration: InputDecoration(
                  labelText: 'Salary Period',
                  border: OutlineInputBorder(),
                ),
                items: ['Per Month', 'Per Week', 'Per Day', 'Per Hour']
                    .map((period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(period),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    salary_period = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a salary period';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ReviewJobDetailsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review Job Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Job Basics Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Job Title: $job_title'),
            Text('Company Name: $company_name'),
            Text('Country: $country'),
            Text('State: $state'),
            Text('City: $city'),
            Text('Street: $street'),
            Text('Pincode: $pincode'),
            SizedBox(height: 20),
            Text('Job Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Job Type: $job_type'),
            Text('Shift Type: $shift_type'),
            Text('Number of People to Hire: $no_people'),
            Text('Number of Years of Experience: $experience_req'),
            Text('Qualifications Required: $qualification_req'),
            //Text('Skills Required: $skill'),
            Text('Job Description: $description'),
            SizedBox(height: 20),
            Text('Salary Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Minimum Salary: $min_salary'),
            Text('Maximum Salary: $max_salary'),
            Text('Salary Period: $salary_period'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void popupdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Submission'),
          content: Text('Do you want to submit?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                post();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void post() async {
    try {
      // Retrieve user ID
      await getUserId();

      // Validate form (uncomment if needed)
      // if (!formKey.currentState!.validate()) {
      //   return;
      // }

      // Retrieve form data
      final title = job_titleController.text;
      final company_name = company_nameControlller.text;
      final country = countryController.text;
      final state = stateController.text;
      final city = cityController.text;
      final street = streetController.text;
      final pincode = pincodeController.text;
      final no_people = no_peopleController.text;
      final experience_req = experience_reqController.text;
      final qualification_req = qualification_reqController.text;
      final description = descriptionController.text;
      final min_salary = min_salaryController.text;
      final max_salary = max_salaryController.text;
      // final job_type = job_typeController.text; // Commented out in your code
      // final shift_type = shift_typeController.text; // Commented out in your code
      // final salary_period = salary_periodController.text; // Commented out in your code

      // Construct URL
      final url = Platform.isAndroid
          ? 'http://10.0.3.2:8000/api/dashboard/job/insert/$user_id'
          : 'http://localhost:8000/api/dashboard/job/insert/$user_id';
      print('Request body: ${jsonEncode({
            'title': title,
            'company_name': company_name,
            'country': country,
            'state': state,
            'city': city,
            'street': street,
            'pincode': pincode,
            'job_type': job_type,
            'shift_type': shift_type,
            'no_people': no_people,
            'experience_req': experience_req,
            'qualification_req': qualification_req,
            'description': description,
            'min_salary': min_salary,
            'max_salary': max_salary,
            'salary_period': salary_period,
          })}');
      // Make POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'company_name': company_name,
          'country': country,
          'state': state,
          'city': city,
          'street': street,
          'pincode': pincode,
          'job_type': job_type, // Make sure this is correctly defined
          // 'shift_type': shift_type, // Make sure this is correctly defined
          'no_people': no_people,
          'experience_req': experience_req,
          'qualification_req': qualification_req,
          'description': description,
          'min_salary': min_salary,
          'max_salary': max_salary,
          'salary_period': salary_period, // Make sure this is correctly defined
        }),
      );

      print('Response body: ${response.body}');

      // Check response status code
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Show success message
        CommonHelper.animatedSnackBar(
          context,
          data['message'],
          AnimatedSnackBarType.success,
        );
        // Navigate to dashboard
        Navigator.pushNamed(context, '/dashboard');
      } else {
        // Show error message
        final data = jsonDecode(response.body);
        CommonHelper.animatedSnackBar(
          context,
          data['message'],
          AnimatedSnackBarType.error,
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      // Show error message
      CommonHelper.animatedSnackBar(
        context,
        'An error occurred while posting the job.',
        AnimatedSnackBarType.error,
      );
    }
  }
}
