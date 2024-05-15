import 'dart:convert';
import 'dart:io';
import 'package:carreerhub/GetuserId.dart';
import 'package:http/http.dart' as http;

int user_id = UserIdStorage.getUserId() as int;

class ApiService {
  static String baseUrl = Platform.isAndroid
      ? 'http://10.0.3.2:8000/api'
      : 'http://127.0.0.1:8000/api';
  static Future<Map<String, dynamic>> registerUser(
      String email, String password,
      {required String route}) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> PostJob(
      String jobtitle,
      String companyname,
      String location,
      String salary,
      String job_type,
      String description,
      {required String route}) async {
        
    final url = Uri.parse('$baseUrl/dashboard/job/insert/$user_id');
    final response = await http.post(
      url,
      body: {
        'jobtitle': jobtitle,
        'companyname': companyname,
        'salary': salary,
        'job_type': job_type,
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

  static Future<Map<String, dynamic>> getUserDetail(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard/user/$userId')); // Send a GET request to the API endpoint with the provided user ID

    if (response.statusCode == 200) { // Check if the response status code is 200 (OK)
      return jsonDecode(response.body); // If successful, return the JSON response
    } else {
      throw Exception('Failed to load user detail'); // If unsuccessful, throw an exception with an error message
    }
  }
}
