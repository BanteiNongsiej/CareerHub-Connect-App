import 'dart:io';
import 'package:carreerhub/GetuserId.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skeletonizer/skeletonizer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController mobileNumberController;
  late TextEditingController emailController;
  late TextEditingController countryController;
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController streetController;
  late TextEditingController pincodeController;

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
      'Meghalaya': ['Shillong', 'Tura', 'Nongpoh', 'Jowai'],
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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with empty values initially
    firstNameController = TextEditingController();
    middleNameController = TextEditingController();
    lastNameController = TextEditingController();
    mobileNumberController = TextEditingController();
    emailController = TextEditingController();
    countryController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();
    streetController = TextEditingController();
    pincodeController = TextEditingController();

    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    await Future.delayed(Duration(seconds: 2)); // Adding a delay of 3 seconds

    final userId = await UserIdStorage.getUserId();
    final url = Platform.isAndroid
        ? 'http://10.0.3.2:8000/api/dashboard/user/getProfile/$userId'
        : 'http://localhost:8000/api/dashboard/user/getProfile/$userId'; // Get the user ID from storage
    var response = await http.get(Uri.parse(url));

    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        firstNameController.text = data['first_name'] ?? '';
        middleNameController.text = data['middle_name'] ?? '';
        lastNameController.text = data['last_name'] ?? '';
        mobileNumberController.text = data['mobile_number'] ?? '';
        emailController.text = data['email'] ?? '';
        countryController.text = data['country'] ?? '';
        stateController.text = data['state'] ?? '';
        cityController.text = data['city'] ?? '';
        streetController.text = data['street'] ?? '';
        pincodeController.text = data['pincode'] ?? '';
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    streetController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Color.fromARGB(255, 142, 233, 237),
      ),
      body: isLoading
          ? Skeletonizer(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  SizedBox(height: 16.0),
                  BuildSkeletonTextField(),
                  BuildSkeletonTextField(),
                  BuildSkeletonTextField(),
                  BuildSkeletonTextField(),
                  BuildSkeletonTextField(),
                  BuildSkeletonTextField(),
                  BuildSkeletonTextField(),
                  BuildSkeletonTextField(),
                  BuildSkeletonTextField(),
                  BuildSkeletonTextField(),
                  SizedBox(height: 16.0),
                  _buildSkeletonButton(),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    BuildTextField('First Name', firstNameController),
                    BuildTextField('Middle Name', middleNameController,
                        validate: false),
                    BuildTextField('Last Name', lastNameController),
                    BuildTextField('Mobile Number', mobileNumberController),
                    BuildTextField('Email', emailController),
                    Divider(),
                    Text(
                      'Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    BuildTextField('Country', countryController,
                        onChanged: (value) {
                      setState(() {
                        stateController.clear();
                        cityController.clear();
                      });
                    }),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: stateController,
                                decoration: InputDecoration(
                                  labelText: 'State',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                if (countryController.text.isEmpty) {
                                  return [];
                                } else {
                                  return states[countryController.text]
                                          ?.where((state) => state
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()))
                                          .toList() ??
                                      [];
                                }
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                    title: Text(suggestion.toString()));
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  stateController.text = suggestion.toString();
                                  cityController.clear();
                                });
                              },
                              noItemsFoundBuilder: (context) => const SizedBox(
                                height: 50,
                                child: Center(child: Text('No states found.')),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: cityController,
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                if (stateController.text.isEmpty) {
                                  return [];
                                } else {
                                  return cities[countryController.text]
                                              ?[stateController.text]
                                          ?.where((city) => city
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()))
                                          .toList() ??
                                      [];
                                }
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                    title: Text(suggestion.toString()));
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  cityController.text = suggestion.toString();
                                });
                              },
                              noItemsFoundBuilder: (context) => const SizedBox(
                                height: 50,
                                child: Center(child: Text('No cities found.')),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    BuildTextField('Street Address', streetController),
                    BuildTextField('Pincode', pincodeController),
                    SizedBox(height: 16.0),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  saveProfile();
                                },
                                child: const Text('Save'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userId = await UserIdStorage.getUserId();
      final url = Platform.isAndroid
          ? 'http://10.0.3.2:8000/api/dashboard/updateProfile/$userId'
          : 'http://localhost:8000/api/dashboard/updateProfile/$userId';
      final request = Uri.parse(url);
      print(userId);
      try {
        final response = await http.put(
          request,
          body: {
            'first_name': firstNameController.text,
            'middle_name': middleNameController.text,
            'last_name': lastNameController.text,
            'mobile_number': mobileNumberController.text,
            'email': emailController.text,
            'country': countryController.text,
            'state': stateController.text,
            'city': cityController.text,
            'street': streetController.text,
            'pincode': pincodeController.text,
          },
        );
        print(response.body);

        if (response.statusCode == 200) {
          // Handle success
          print('Profile updated successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context);
        } else {
          // Handle API errors
          print('Failed to update profile: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile')),
          );
        }
      } catch (e) {
        // Handle network errors
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile')),
        );
      }
    }
  }

  Widget BuildTextField(String labelText, TextEditingController controller,
      {bool validate = true,
      bool enabled = true,
      Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration:
            InputDecoration(labelText: labelText, border: OutlineInputBorder()),
        validator: (value) {
          if (validate && (value == null || value.isEmpty)) {
            return '$labelText is required';
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }

  Widget BuildSkeletonTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        height: 56.0,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildSkeletonButton() {
    return Container(
      width: double.infinity,
      height: 48.0,
      color: Colors.grey[300],
    );
  }
}
