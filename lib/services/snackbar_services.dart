import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnackBarServices {
  BuildContext _buildContext;

  static SnackBarServices instace = SnackBarServices();

  SnackBarServices();

  set buildContext(BuildContext _context) {
    _buildContext = _context;
  }

  void showSnackbarError(String _message) {
    ScaffoldMessenger.of(_buildContext).showSnackBar(
      SnackBar(
        content: Text(
          _message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSnackbarSuccess(String _message) {
    ScaffoldMessenger.of(_buildContext).showSnackBar(
      SnackBar(
        content: Text(
          _message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
}
