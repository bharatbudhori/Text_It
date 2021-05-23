import 'package:chati_fy/models/contact.dart';
import 'package:chati_fy/pages/conversation_page.dart';
import 'package:chati_fy/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchPage extends StatefulWidget {
  final _height;
  final _width;

  SearchPage(this._height, this._width);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AuthProvider _auth;
  String _searchText;

  _SearchPageState() {
    _searchText = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _searchPageUI(),
      ),
    );
  }

  Widget _searchPageUI() {
    return SingleChildScrollView(
      child: Builder(
        builder: (_context) {
          _auth = Provider.of<AuthProvider>(_context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _userSearchField(),
              _userListView(),
            ],
          );
        },
      ),
    );
  }

  Widget _userSearchField() {
    return Container(
      height: this.widget._height * 0.08,
      width: this.widget._width,
      padding: EdgeInsets.symmetric(vertical: this.widget._height * 0.02),
      child: TextField(
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        onSubmitted: (_input) {
          setState(() {
            _searchText = _input;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          labelText: 'Search',
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _userListView() {
    return StreamBuilder<List<Contact>>(
      stream: DBService.instance.getUsersInDB(_searchText),
      builder: (_context, _snapshot) {
        var _usersData = _snapshot.data;
        if (_usersData != null) {
          _usersData.removeWhere((element) => element.id == _auth.user.uid);
        }

        return !_snapshot.hasData
            ? Center(
                child: SpinKitPouringHourglass(
                  color: Colors.blue,
                ),
              )
            : Container(
                height: this.widget._height * 0.75,
                child: ListView.builder(
                  itemCount: _usersData.length,
                  itemBuilder: (_context, _index) {
                    var _userData = _usersData[_index];
                    var _recepientID = _usersData[_index].id;
                    var _currentTime = DateTime.now();
                    var _isUserActive = !_userData.lastSeen.toDate().isBefore(
                          _currentTime.subtract(
                            Duration(minutes: 1),
                          ),
                        );
                    return ListTile(
                      onTap: () {
                        DBService.instance.createOrGetConversation(
                          _auth.user.uid,
                          _recepientID,
                          (String _conversationID) {
                            NavigationServices.instance.navigateToRoute(
                              MaterialPageRoute(
                                builder: (_context) {
                                  return ConversationPage(
                                    _conversationID,
                                    _recepientID,
                                    _userData.name,
                                    _userData.image,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      title: Text(_userData.name),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          _userData.image,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _isUserActive ? 'Active Now' : 'Last seen',
                            style: TextStyle(fontSize: 13),
                          ),
                          _isUserActive
                              ? CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 6,
                                )
                              : Text(
                                  timeago.format(
                                    _userData.lastSeen.toDate(),
                                  ),
                                  style: TextStyle(fontSize: 13),
                                ),
                        ],
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
