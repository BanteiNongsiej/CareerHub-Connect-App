import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class JobPostBasic extends StatefulWidget {
  @override
  _JobPostBasicState createState() => _JobPostBasicState();
}

class _JobPostBasicState extends State<JobPostBasic> {
  final _formKey = GlobalKey<FormState>();

  int user_id = 0;
  final titleController = TextEditingController();
  final companynameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();

  String title = '';
  String company_name = '';
  String street = '';
  String country = 'India';
  String? state;
  String? city;
  String pincode = '';

  final Map<String, List<String>> _states = {
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

  final Map<String, Map<String, List<String>>> _cities = {
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

  List<String> _getStates(String country) {
    return _states[country] ?? [];
  }

  List<String> _getCities(String country, String state) {
    return _cities[country]?[state] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Job Basics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Add job basics',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              // Job title
              SizedBox(height: 10),
              Image.asset(
                'images/job_basics.png',
                width: 500,
                height: 150,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Job title *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job title';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
              SizedBox(height: 16),

              // Company name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Company name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  company_name = value!;
                },
              ),
              SizedBox(height: 16),

              // Country
              TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    labelText: 'Country *',
                    border: OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _states[country]!
                      .where((state) =>
                          state.toLowerCase().startsWith(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    country = suggestion;
                  });
                  countryController.text = suggestion;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the country';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // State
              TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    labelText: 'State *',
                    border: OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _getStates(country)
                      .where((state) =>
                          state.toLowerCase().startsWith(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    state = suggestion;
                    city = null;
                  });
                  stateController.text = suggestion;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a state';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // City
              TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    labelText: 'City *',
                    border: OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  // Check if state is not null before calling _getCities
                  if (state != null) {
                    return _getCities(country, state!)
                        .where((city) => city
                            .toLowerCase()
                            .startsWith(pattern.toLowerCase()))
                        .toList();
                  } else {
                    return []; // Return an empty list if state is null
                  }
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    city = suggestion;
                  });
                  cityController.text = suggestion;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Street address
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Street address',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  street = value!;
                },
              ),
              SizedBox(height: 16),

              // Pincode
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pincode',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  pincode = value!;
                },
              ),
              SizedBox(height: 16),

              // Continue and Back buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle back action
                      },
                      child: Text('Back'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.pushNamed(context, '/jobpostdetails');
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
    );
  }
}
