//import 'package:carreerhub/splash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:carreerhub/login.dart';
import 'package:carreerhub/api.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String email = "";
  String password = "";

  void setData() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final response = await ApiService.registerUser(email, password, route: '');
    if (response['status'] == 200) {
      //ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/login');
    } else {
      //ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Registration Failed'),
              content: Text(response['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Registration'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
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
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      //setData();
                      setState(() {
                        isLoading = true;
                      });
                      Future.delayed(const Duration(seconds: 1), () {});
                      setData();
                    },
                    child: isLoading == true
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Register',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already a user? Click here to login',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/login');
                          },
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
