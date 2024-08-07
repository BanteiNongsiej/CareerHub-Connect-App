import 'dart:convert';
import 'dart:io';
import 'package:carreerhub/GetuserId.dart';
import 'package:carreerhub/helper/commonhelper.dart';
import 'package:carreerhub/model/loginModel.dart';
import 'package:carreerhub/provider/userprovider.dart';
import 'package:carreerhub/token.dart';
import 'package:http/http.dart' as http;
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  LoginModel login = LoginModel.initial();
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login Form'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Form(
        key: _loginFormKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: .0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Email required';
                      } else if (value.length < 4) {
                        return 'Invalide email entered';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Password required';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      //add delay
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          isLoading = false;
                        });
                      });
                      loginnow();
                    },
                    child: isLoading
                        ? SizedBox(
                            width: 25,
                            height: 25,
                            child: const CircularProgressIndicator(
                              strokeWidth: 4,
                              color: Colors.black,
                            ))
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                  ),
                  const SizedBox(height: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'If not registered? Click here to register',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 0), // Add some space between buttons
                      TextButton(
                        onPressed: () {
                          // Handle forgot password action
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginnow() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      String url = '';
      String email = emailController.text;
      String password = passwordController.text;
      if (Platform.isAndroid) {
        url = 'http://10.0.3.2:8000/api/login';
      } else {
        url = 'http://localhost:8000/api/login';
      }
      try {
        var response = await http.post(Uri.parse(url), body: {
          'email': email,
          'password': password
        }, headers: {
          'Accept': 'application/json',
          // 'Content-Type': 'application/json'
        });
        var data = jsonDecode(response.body);
        if ((response.statusCode) == 200) {
          String token = data['token'];
          await AuthTokenStorage.saveToken(token);
          int user_id = data['user_id'];
          print(token);
          await UserIdStorage.saveUserId(user_id);
          if (data['email'] == 'banteilangnongsiej04@gmail.com') {
            CommonHelper.animatedSnackBar(
                context, data['message'], AnimatedSnackBarType.success);
            Navigator.pushNamed(context, '/admindashboard');
          } else {
            CommonHelper.animatedSnackBar(
                context, data['message'], AnimatedSnackBarType.success);
            Navigator.pushNamed(context, '/dashboard');
          }
        } else if (response.statusCode == 404) {
          CommonHelper.animatedSnackBar(
              context, data['message'], AnimatedSnackBarType.error);
        } else {
          print(response.statusCode);
          //set the user id to the provider
          // ignore: use_build_context_synchronously
          Provider.of<UserProvider>(context, listen: false)
              .setUser_id(data['id']);
          // ignore: use_build_context_synchronously
          if (data['email'] == 'banteilangnongsiej04@gmail.com') {
            Navigator.pushNamed(context, '/admindashboard');
          } else {
            Navigator.pushNamed(context, '/dashboard');
          }
        }
      } catch (e) {
        print(' $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
