import 'dart:io';

import 'package:chati_fy/models/message.dart';
import 'package:chati_fy/services/cloud_storage_service.dart';
import 'package:chati_fy/services/media_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

import '../services/db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationPage extends StatefulWidget {
  String _conversationID;
  String _recieverID;
  String _recieverName;
  String _recieverImage;

  ConversationPage(
    this._conversationID,
    this._recieverID,
    this._recieverName,
    this._recieverImage,
  );

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  double _deviceHeight;
  double _deviceWidth;

  AuthProvider _auth;
  GlobalKey<FormState> _formKey;
  String _messageText;

  _ConversationPageState() {
    _formKey = GlobalKey<FormState>();
    _messageText = '';
  }

  @override
  Widget build(BuildContext context) {
    //print(_messageText);
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(this.widget._recieverName),
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
        ),
        body: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: _conversationPageUI(),
        ));
  }

  Widget _conversationPageUI() {
    return Builder(
      builder: (_context) {
        _auth = Provider.of<AuthProvider>(_context);
        return Stack(
          overflow: Overflow.visible,
          children: [
            _messageListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: _messageField(_context),
            ),
          ],
        );
      },
    );
  }

  Widget _messageListView() {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      child: StreamBuilder(
        stream: DBService.instance.getCOnversation(this.widget._conversationID),
        builder: (_context, _snapshot) {
          var _conversationData = _snapshot.data;
          if (_conversationData != null) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              itemCount: _conversationData.message.length,
              itemBuilder: (_context, _index) {
                var _message = _conversationData.message[_index];
                bool isOwnMessage = _message.senderID == _auth.user.uid;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: isOwnMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      !isOwnMessage ? _userImageWidget() : Text(''),
                      _message.type == MessageType.Text
                          ? _textMessageBubble(
                              isOwnMessage,
                              _message.content,
                              _message.timestamp,
                            )
                          : _imageMessageBubble(
                              isOwnMessage,
                              _message.content,
                              _message.timestamp,
                            )
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: SpinKitPouringHourglass(
                color: Colors.blue,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _userImageWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(this.widget._recieverImage),
      ),
    );
  }

  Widget _textMessageBubble(
      bool _isOwnMessage, String _message, Timestamp _timesatmp) {
    List<Color> _colorScheme = _isOwnMessage
        ? [Colors.blue, Color.fromRGBO(42, 117, 188, 1)]
        : [Color.fromRGBO(69, 69, 69, 1), Color.fromRGBO(43, 43, 43, 1)];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      height: _deviceHeight * 0.10 + (_message.length / 20 * 5.0),
      width: _deviceWidth * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_message),
          Text(
            timeago.format(_timesatmp.toDate()),
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }

  Widget _imageMessageBubble(
      bool _isOwnMessage, String _imageUrl, Timestamp _timesatmp) {
    List<Color> _colorScheme = _isOwnMessage
        ? [Colors.blue, Color.fromRGBO(42, 117, 188, 1)]
        : [Color.fromRGBO(69, 69, 69, 1), Color.fromRGBO(43, 43, 43, 1)];
    DecorationImage _image = DecorationImage(
      image: NetworkImage(_imageUrl),
      fit: BoxFit.cover,
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      height: _deviceHeight * 0.10 + (_imageUrl.length / 20 * 5.0),
      width: _deviceWidth * 0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: _deviceHeight * 0.30,
            width: _deviceWidth * 0.40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: _image,
            ),
          ),
          Text(
            timeago.format(_timesatmp.toDate()),
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }

  Widget _messageField(BuildContext _context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.03,
        vertical: _deviceHeight * 0.02,
      ),
      height: _deviceHeight * 0.07,
      decoration: BoxDecoration(
        color: Color.fromRGBO(43, 43, 43, 1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(_context),
            _imageMessageButton(_context),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.55,
      child: TextFormField(
        validator: (_input) {
          if (_input.trim().length == 0) {
            return null;
          }
          return null;
        },
        onChanged: (_input) {
          _formKey.currentState.save();
        },
        onSaved: (_input) {
          setState(() {
            _messageText = _input;
          });
        },
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type a message',
        ),
        autocorrect: true,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
      ),
    );
  }

  Widget _sendMessageButton(BuildContext _context) {
    return CircleAvatar(
      backgroundColor: Color.fromRGBO(43, 43, 43, 1),
      child: IconButton(
        icon: Icon(
          Icons.send,
          color: _messageText.trim().length == 0 ? Colors.grey : Colors.white,
        ),
        onPressed: _messageText.trim().length == 0
            ? null
            : () {
                if (_formKey.currentState.validate()) {
                  DBService.instance.sendMessage(
                    this.widget._conversationID,
                    Message(
                      content: _messageText,
                      timestamp: Timestamp.now(),
                      senderID: _auth.user.uid,
                      type: MessageType.Text,
                    ),
                  );
                }
                _formKey.currentState.reset();
                FocusScope.of(context).unfocus();
              },
      ),
    );
  }

  Widget _imageMessageButton(BuildContext _context) {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      child: FloatingActionButton(
        onPressed: () async {
          File _image =
              await MediaService.instance.getIamgeFromLibrary('gallery');
          if (_image != null) {
            var _result = await CloudStorageService.instance
                .uploadMediaMessage(_auth.user.uid, _image);
            print('$_result ???????????');
            var _imageURL = await _result.ref.getDownloadURL();
            await DBService.instance.sendMessage(
              this.widget._conversationID,
              Message(
                content: _imageURL,
                senderID: _auth.user.uid,
                timestamp: Timestamp.now(),
                type: MessageType.Image,
              ),
            );
          } else {
            print('NO image taken');
          }
        },
        child: Icon(Icons.camera_enhance),
      ),
    );
  }
}
