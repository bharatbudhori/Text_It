import 'package:cloud_firestore/cloud_firestore.dart';

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
