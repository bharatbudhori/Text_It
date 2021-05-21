import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

class ConversationSnippet {
  final String id;
  final String conversationID;
  final String lastMessage;
  final String name;
  final String image;
  final int unseenCount;
  final Timestamp timestamp;

  ConversationSnippet({
    this.conversationID,
    this.id,
    this.image,
    this.lastMessage,
    this.name,
    this.timestamp,
    this.unseenCount,
  });

  factory ConversationSnippet.fromFirestore(dynamic _snapshot) {
    var _data = _snapshot.data();
    return ConversationSnippet(
      id: _snapshot.id,
      conversationID: _data['conversationID'],
      lastMessage: _data['lastMessage'] != null ? _data['lastMessage'] : '',
      unseenCount: _data['unseenCount'],
      name: _data['name'],
      image: _data['image'],
    );
  }
}

class Conversation {
  final String id;
  final List members;
  final List<Message> message;
  final String ownerID;

  Conversation({
    this.id,
    this.members,
    this.message,
    this.ownerID,
  });

  factory Conversation.fromFirestore(dynamic _snapshot) {
    var _data = _snapshot.data();
    List _messages = _data['messages'];
    if (_messages != null) {
      _messages = _messages.map((e) {
        var _messageType =
            e['type'] == 'text' ? MessageType.Text : MessageType.Image;
        return Message(
          senderID: e['senderID'],
          content: e['message'],
          timestamp: e['timestamp'],
          type: _messageType,
        );
      }).toList();
    } else {
      _messages = null;
    }
    return Conversation(
        id: _snapshot.id,
        members: _data['members'],
        ownerID: _data['ownerID'],
        message: _messages);
  }
}
