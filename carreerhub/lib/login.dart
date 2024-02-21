import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Text(
          'Login Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
