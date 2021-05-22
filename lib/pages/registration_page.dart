import 'dart:io';

import 'package:chati_fy/services/cloud_storage_service.dart';
import 'package:chati_fy/services/db_service.dart';
import 'package:chati_fy/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

import '../services/media_service.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> _formKey;
  File _image;
  String _name;
  String _email;
  String _password;
  AuthProvider _auth;

  BuildContext parentContext;

  double _deviceHeight;
  double _deviceWidth;

  _RegistrationPageState() {
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    parentContext = context;
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: regestrationPageUI(),
        ),
      ),
    );
  }

  Widget regestrationPageUI() {
    return Builder(
      builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(25),
            //color: Colors.red,
            height: _deviceHeight * 0.80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headingWidget(),
                _inputForm(),
                _registerButton(),
                _backToLoginPageButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _headingWidget() {
    return Container(
      height: _deviceHeight * 0.13,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going! ",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Please enter your details.',
            softWrap: true,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w200,
            ),
          )
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Container(
      height: _deviceHeight * 0.40,
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageSelectorWidget(),
            _nameTextField(),
            _emailTextField(),
            _passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget imageSelectorWidget() {
    return GestureDetector(
      onTap: () {
        return showDialog(
            context: parentContext,
            builder: (context) {
              return SimpleDialog(
                title: Text(
                  'Select image',
                  style: TextStyle(fontSize: 25),
                ),
                children: [
                  SimpleDialogOption(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Photo with Camera',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: handleTakePhoto,
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Image from Gallery',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: handleChooseFromGallery,
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      },
      child: Container(
        alignment: Alignment.center,
        child: CircleAvatar(
          radius: _deviceHeight * 0.06,
          backgroundColor: Colors.grey,
          backgroundImage: _image == null
              ? NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNOhpV67XSI4Vz5Z_L7XoWiH7UzZQDBTzS3g&usqp=CAU',
                )
              : FileImage(_image),
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      autocorrect: false,
      style: TextStyle(
        color: Colors.white,
      ),
      validator: (_input) {
        return (_input.length != 0) ? null : 'Please enter a name';
      },
      onSaved: (_input) {
        setState(() {
          _name = _input;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Name',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
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
          _email = _input;
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
          _password = _input;
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

  Widget _registerButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: _deviceHeight * 0.06,
      width: _deviceWidth,
      child: _auth.status == AuthStatus.Authenticating
          ? Center(child: CircularProgressIndicator())
          : MaterialButton(
              onPressed: () {
                if (_formKey.currentState.validate() && _image != null) {
                  _auth.registerUserWithEmailAndPassword(_email, _password,
                      (String _uid) async {
                    var _result = await CloudStorageService.instance
                        .uploadUserImage(_uid, _image);
                    var _imageURL = await _result.ref.getDownloadURL();
                    await DBService.instance
                        .createUserInDB(_uid, _name, _email, _imageURL);
                  });
                }
              },
              color: Colors.blue,
              child: Text(
                'REGISTER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }

  Widget _backToLoginPageButton() {
    return Container(
      height: _deviceHeight * 0.06,
      width: _deviceWidth,
      alignment: Alignment.center,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 35,
        ),
        color: Colors.white,
        onPressed: () {
          NavigationServices.instance.goBack();
        },
      ),
    );
  }

  handleTakePhoto() async {
    Navigator.of(parentContext).pop();
    File _imageFile = await MediaService.instance.getIamgeFromLibrary('camera');
    setState(() {
      _image = _imageFile;
    });
  }

  handleChooseFromGallery() async {
    Navigator.of(parentContext).pop();
    File _imageFile =
        await MediaService.instance.getIamgeFromLibrary('gallery');
    setState(() {
      _image = _imageFile;
    });
  }
}
