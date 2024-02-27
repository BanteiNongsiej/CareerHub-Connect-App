import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int user_id = 0;
  void setUser_id(int id) {
    user_id = id;
    notifyListeners();
  }
}
