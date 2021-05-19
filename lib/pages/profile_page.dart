import 'package:chati_fy/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/auth_provider.dart';
import '../services/db_service.dart';

class ProfilePage extends StatelessWidget {
  final double _height;
  final double _width;
  AuthProvider _auth;

  ProfilePage(
    this._height,
    this._width,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _profilePageUI(),
      ),
    );
  }

  Widget _profilePageUI() {
    return Builder(
      builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return StreamBuilder<Contact>(
          stream: DBService.instance.getUserData(_auth.user.uid),
          builder: (_context, _snapshot) {
            var _userData = _snapshot.data;
            // return _snapshot.connectionState == ConnectionState.waiting
            //     ? Center(
            //         child: SpinKitPouringHourglass(
            //           color: Colors.blue,
            //         ),
            //       )
            //:
            return Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: _height * 0.50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _userImageWidget('_userData.image'),
                    _userNameWidget('_userData.name'),
                    _userEmailWidget('_userData.email'),
                    _logoutButton(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _userImageWidget(String _image) {
    return CircleAvatar(
      radius: _height * 0.10,
      backgroundImage: NetworkImage(_image),
      backgroundColor: Colors.grey,
    );
  }

  Widget _userNameWidget(String _userName) {
    return Container(
      height: _height * 0.05,
      width: _width,
      child: Text(
        _userName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _userEmailWidget(String _email) {
    return Container(
      height: _height * 0.03,
      width: _width,
      child: Text(
        _email,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      height: _height * 0.06,
      width: _width * 0.80,
      child: MaterialButton(
        onPressed: () {
          _auth.logoutUser(() {});
        },
        child: Text(
          'LOGOUT',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        color: Colors.red,
      ),
    );
  }
}
