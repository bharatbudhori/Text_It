import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/snackbar_services.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error,
}

class AuthProvider with ChangeNotifier {
  AuthStatus status;
  User user;

  dynamic _auth;

  static AuthProvider instance = AuthProvider();
  AuthProvider() {
    _auth = FirebaseAuth.instance;
  }

  void loginUserWithEmailAndPassword(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      dynamic _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      SnackBarServices.instace.showSnackbarSuccess('Welcome ${user.email} !');
      print('user authenticated successfully');

      //navigate to HomePage

    } catch (error) {
      status = AuthStatus.Error;
      SnackBarServices.instace
          .showSnackbarError('Error, could not authenticate user.');
      print('login error ');
      //Display an error

    }
    notifyListeners();
  }
}
