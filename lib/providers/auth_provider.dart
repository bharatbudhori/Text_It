import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider instance = AuthProvider();
  AuthProvider() {}

  void loginUserWithEmailAndPassword(String _email, String _password) {
    try {} catch (error) {}
  }
}
