import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = Platform.isAndroid
      ? 'http://10.0.3.2:8000/api'
      : 'http://127.0.0.1:8000/api';

  static Future<Map<String, dynamic>> registerUser(
      String email, String password,
      {required String route}) async {
    final url = Uri.parse('$baseUrl/register'); // Adjust endpoint accordingly
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> PostJob(String jobtitle,
      String companyname, String location, String salary,String job_type, String description,
      {required String route}) async {
    final url = Uri.parse(
        '$baseUrl/dashboard/job/insert'); // Adjust endpoint accordingly
    final response = await http.post(
      url,
      body: {
        'jobtitle': jobtitle,
        'companyname': companyname,
        'salary': salary,
        'job_type':job_type,
        'location': location,
        'description': description,
      },
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/login'); // Adjust endpoint accordingly
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    return json.decode(response.body);
  }
}
