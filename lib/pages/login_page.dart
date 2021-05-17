import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/snackbar_services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _deviceHeight;
  double _deviceWidth;

  AuthProvider _auth;

  GlobalKey<FormState> _formKey;

  String _email;
  String _password;

  _LoginPageState() {
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.height;

    SnackBarServices.instace.buildContext = context;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
          child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _loginPageUI(),
      )),
    );
  }

  Widget _loginPageUI() {
    // print(_email);
    // print(_password);
    return Builder(
      builder: (context) {
        SnackBarServices.instace.buildContext = context;
        _auth = Provider.of<AuthProvider>(context);
        //print(_auth.user);
        return ListView(
          children: [
            Container(
              padding: EdgeInsets.all(25),
              height: _deviceHeight * 0.6,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headingWidget(),
                  _inputForm(),
                ],
              ),
            ),
            Container(
              height: _deviceHeight * 0.3,
              child: Image.network(
                'https://images.unsplash.com/photo-1473081556163-2a17de81fc97?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _headingWidget() {
    return Container(
      height: _deviceHeight * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back!',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Please login to your account.',
            softWrap: true,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
            ),
          )
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Container(
      height: _deviceHeight * 0.3,
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _emailTextField(),
            _passwordTextField(),
            _loginButton(),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      autocorrect: false,
      style: TextStyle(
        color: Colors.white,
      ),
      validator: (_input) {
        return (_input.length != 0 && _input.contains('@'))
            ? null
            : 'Please enter a valid email';
      },
      onSaved: (_input) {
        setState(() {
          _email = _input.trim();
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Email address',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      style: TextStyle(
        color: Colors.white,
      ),
      validator: (_input) {
        return _input.trim().length > 4 ? null : 'Password too short';
      },
      onSaved: (_input) {
        setState(() {
          _password = _input.trim();
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Password',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return _auth.status == AuthStatus.Authenticating
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: _deviceHeight * 0.06,
            width: _deviceWidth,
            child: MaterialButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print('Valid credential');
                  _auth.loginUserWithEmailAndPassword(_email, _password);

                  //login user

                }
              },
              color: Colors.blue,
              child: Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
  }

  Widget _registerButton() {
    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          'REGISTER',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}
