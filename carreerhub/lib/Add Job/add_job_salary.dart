import 'package:flutter/material.dart';

class JobPostSalary extends StatefulWidget {
  @override
  _JobPostSalaryState createState() => _JobPostSalaryState();
}

class _JobPostSalaryState extends State<JobPostSalary> {
  final formKey = GlobalKey<FormState>();
  String? minimumSalary;
  String? maximumSalary;
  String? exactAmount;
  String? rate;
  String? selectedPaymentMethod = 'Range'; // Set default value to 'Range'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salary Details'),
      ),
      body: SingleChildScrollView(
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
                SizedBox(height:16),
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
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter minimum salary',
                      labelText: 'Minimum Salary',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the minimum salary';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      //minimumSalary = double.tryParse(value!);
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter maximum salary',
                      labelText: 'Maximum Salary',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the maximum salary';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      //maximumSalary = double.tryParse(value!);
                    },
                  ),
                ],
                if (selectedPaymentMethod == 'Exact Amount') ...[
                  Text(
                    'Exact Salary Amount',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter exact salary amount',
                      labelText: 'Exact Salary Amount',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the exact salary amount';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      //exactAmount = double.tryParse(value!);
                    },
                  ),
                ],
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: rate,
                  onChanged: (value) {
                    setState(() {
                      rate = value;
                    });
                  },
                  items: ['Per Month', 'Per Year', 'Per Hour', 'Per Week', 'Per Day']
                      .map((rate) => DropdownMenuItem<String>(
                            value: rate,
                            child: Text(rate),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    hintText: 'Select rate',
                    labelText: 'Rate',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            Navigator.pushNamed(context, '/jobpostsalary');
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
      ),
    );
  }
}
