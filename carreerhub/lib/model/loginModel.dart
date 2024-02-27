// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoginModel {
  late String email;
  late String password;

  LoginModel({required this.email, required this.password});

  // set default value
  factory LoginModel.initial() {
    return LoginModel(email: 'bahrit@gmail.com', password: 'password');
  }
}
