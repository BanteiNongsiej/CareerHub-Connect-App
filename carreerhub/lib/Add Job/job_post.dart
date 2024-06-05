import 'package:carreerhub/GetuserId.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final skillController = TextEditingController();
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
  String job_type = 'Select an option';
  String shift_type = 'Select an option';
  String no_people = '';
  String experience_req = '';
  String qualification_req = '';
  String description = '';
  String skill = '';

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

  void nextPage() {
    if (_currentPage < 2) {
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
          if (_currentPage != 2)
            ElevatedButton(
              onPressed: nextPage,
              child: Text('Next'),
            ),
          if (_currentPage == 2)
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.pushNamed(context, '/reviewresume');
                }
              },
              child: Text('Review'),
            ),
        ],
      ),
    );
  }

  Widget JobBasicsDetails() {
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
              onChanged: (value) => job_title = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: company_nameControlller,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => company_name = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: countryController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => country = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: countryController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => state = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: countryController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => city = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: countryController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Street',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => street = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: countryController,
              keyboardType: TextInputType.number,
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

  Widget JobDetailsPage() {
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
              value: shift_type,
              decoration: InputDecoration(
                labelText: 'Shift Type *',
                border: OutlineInputBorder(),
              ),
              items: [
                'Select an option',
                'Day Shift',
                'Night Shift',
                'Flexible Shift'
              ].map((type) {
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
              validator: (value) {
                if (value == 'Select an option') {
                  return 'Please select a shift type';
                }
                return null;
              },
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
                no_people = value;
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
                experience_req = value;
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
                qualification_req = value;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: skillController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Skills Required',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                skill = value;
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
                description = value;
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the maximum salary';
                    }
                    return null;
                  },
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
}
