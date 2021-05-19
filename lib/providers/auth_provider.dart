import 'package:chati_fy/services/navigation_service.dart';
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

    //print(_auth.currentUser);
    chechCurrentUserIsAuthenticated();
  }

  void autoLogin() {
    if (user != null) {
      NavigationServices.instance.navigateToReplacement('home');
    }
  }

  void chechCurrentUserIsAuthenticated() async {
    user = await _auth.currentUser;
    if (user != null) {
      print(user.email);
      // print(user.photoURL);
      NavigationServices.instance.navigateToReplacement('home');
    }
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
      NavigationServices.instance.navigateToReplacement('home');
    } catch (error) {
      status = AuthStatus.Error;
      user = null;
      SnackBarServices.instace
          .showSnackbarError('Error, could not authenticate user.');
      print('login error ');
      //Display an error

    }
    notifyListeners();
  }

  void registerUserWithEmailAndPassword(String _email, String _password,
      Future<void> onSuccess(String _uid)) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      dynamic _result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      await onSuccess(user.uid);
      SnackBarServices.instace.showSnackbarSuccess('Welcome ${user.email} !');
      print('user authenticated successfully');
      //update last seen time.
      //NavigationServices.instance.goBack();
      NavigationServices.instance.navigateToReplacement('home');
    } catch (error) {
      status = AuthStatus.Error;
      user = null;
      SnackBarServices.instace
          .showSnackbarError('Error, could not register user.');
      print('login error ');
      //Display an error

    }
    notifyListeners();
  }

  void logoutUser(Future<void> onSuccess()) async {
    try {
      print('logging out');
      await _auth.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      await onSuccess();
      NavigationServices.instance.navigateToReplacement('login');
      // SnackBarServices.instace
      //     .showSnackbarSuccess('User logged out successfully');
    } catch (error) {
      SnackBarServices.instace.showSnackbarError('Error logging out');
    }
    notifyListeners();
  }
}
