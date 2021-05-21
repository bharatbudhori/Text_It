import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(this.widget._recieverName),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
      ),
      body: _conversationPageUI(),
    );
  }

  Widget _conversationPageUI() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        _messageListView(),
      ],
    );
  }

  Widget _messageListView() {
    return Container(
      height: _deviceHeight * 0.75,
      width: _deviceWidth,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (_context, _index) {
          return _textMessageBubble(true, "Heya buddy, how are you?");
        },
      ),
    );
  }

  Widget _textMessageBubble(bool _isOwnMessage, String _message) {
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
      height: _deviceHeight * 0.10,
      width: _deviceWidth * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_message),
          Text(
            'A moment ago',
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}
