// import 'package:flutter/material.dart';

// class ReviewJobDetailsPage extends StatelessWidget {
//   final String jobTitle;
//   final String companyName;
//   final String country;
//   final String state;
//   final String city;
//   final String street;
//   final String pincode;
//   final String jobType;
//   final String shiftType;
//   final String noPeople;
//   final String experienceReq;
//   final String qualificationReq;
//   final String description;
//   final String skill;
//   final String minSalary;
//   final String maxSalary;
//   final String salaryPeriod;

//   ReviewJobDetailsPage({
//     required this.jobTitle,
//     required this.companyName,
//     required this.country,
//     required this.state,
//     required this.city,
//     required this.street,
//     required this.pincode,
//     required this.jobType,
//     required this.shiftType,
//     required this.noPeople,
//     required this.experienceReq,
//     required this.qualificationReq,
//     required this.description,
//     required this.skill,
//     required this.minSalary,
//     required this.maxSalary,
//     required this.salaryPeriod,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Review Job Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Job Basics Detail',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text('Job Title: $jobTitle'),
//             Text('Company Name: $companyName'),
//             Text('Country: $country'),
//             Text('State: $state'),
//             Text('City: $city'),
//             Text('Street: $street'),
//             Text('Pincode: $pincode'),
//             SizedBox(height: 24),
//             Text(
//               'Job Details',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text('Job Type: $jobType'),
//             Text('Shift Type: $shiftType'),
//             Text('Number of People to Hire: $noPeople'),
//             Text('Number of Years of Experience: $experienceReq'),
//             Text('Qualifications Required: $qualificationReq'),
//             Text('Description: $description'),
//             Text('Skills Required: $skill'),
//             SizedBox(height: 24),
//             Text(
//               'Salary Details',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text('Minimum Salary: $minSalary'),
//             Text('Maximum Salary: $maxSalary'),
//             Text('Salary Period: $salaryPeriod'),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 popupdialog(context);
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

  // void popupdialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Confirm Submission'),
  //         content: Text('Do you want to submit?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               post();
  //             },
  //             child: Text('Submit'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
//   void post() async{
//     if(formKey)
//   }
// }
