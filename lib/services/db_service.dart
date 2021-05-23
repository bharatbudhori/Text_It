import 'dart:async';

import 'package:chati_fy/models/contact.dart';
import 'package:chati_fy/models/conversation.dart';
import 'package:chati_fy/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static DBService instance = DBService();

  FirebaseFirestore _db;

  DBService() {
    _db = FirebaseFirestore.instance;
  }
  String _userCollection = 'Users';
  String _conversationsCollection = 'Conversations';

  Future<void> createUserInDB(
    String _uid,
    String _name,
    String _email,
    String _imageURL,
  ) async {
    try {
      return await _db.collection(_userCollection).doc(_uid).set({
        'name': _name,
        'email': _email,
        'image': _imageURL,
        'lastSeen': DateTime.now().toUtc(),
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateUserLastseenCount(String _userID) {
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.update(
      {
        'lastSeen': Timestamp.now(),
      },
    );
  }

  Future<void> sendMessage(String _conversationID, Message _message) {
    var _ref = _db.collection(_conversationsCollection).doc(_conversationID);
    var _messageType = '';
    switch (_message.type) {
      case MessageType.Text:
        _messageType = 'text';
        break;
      case MessageType.Image:
        _messageType = 'image';
        break;
      default:
    }
    return _ref.update(
      {
        'messages': FieldValue.arrayUnion(
          [
            {
              'message': _message.content,
              'senderID': _message.senderID,
              'timestamp': _message.timestamp,
              'type': _messageType,
            },
          ],
        ),
      },
    );
  }

  void createOrGetConversation(
    String _currentID,
    String _recepientID,
    Future<void> _onSuccess(String _conversationID),
  ) async {
    var _ref = _db.collection(_conversationsCollection);
    var _userConversationRef = _db
        .collection(_userCollection)
        .doc(_currentID)
        .collection(_conversationsCollection);
    try {
      dynamic conversation = await _userConversationRef.doc(_recepientID).get();
      if (conversation.data() != null) {
        return _onSuccess(conversation.data['conversationID']);
      } else {
        var _conversationRef = _ref.doc();
        await _conversationRef.set(
          {
            'members': [_currentID, _recepientID],
            'ownerID': [_currentID],
          },
        );
        return _onSuccess(_conversationRef.id);
      }
    } catch (error) {
      print(error);
    }
  }

  Stream<Contact> getUserData(String _userID) {
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.snapshots().map((_snapshot) {
      return Contact.fromFirestore(_snapshot);
    });
  }

  Stream<List<ConversationSnippet>> getUSerConversations(String _userID) {
    var ref = _db
        .collection(_userCollection)
        .doc(_userID)
        .collection('Conversations');
    return ref.snapshots().map(
      (_snapshot) {
        return _snapshot.docs.map((_doc) {
          return ConversationSnippet.fromFirestore(_doc);
        }).toList();
      },
    );
  }

  Stream<List<Contact>> getUsersInDB(String _searchName) {
    var _ref = _db
        .collection(_userCollection)
        .where("name", isGreaterThanOrEqualTo: _searchName)
        .where('name', isLessThan: _searchName + 'z');
    return _ref.get().asStream().map(
      (_snapshots) {
        return _snapshots.docs.map((_doc) {
          return Contact.fromFirestore(_doc);
        }).toList();
      },
    );
  }

  Stream getCOnversation(String _conversationID) {
    var _ref = _db.collection(_conversationsCollection).doc(_conversationID);

    return _ref.snapshots().map((_snapshot) {
      return Conversation.fromFirestore(_snapshot);
    });
  }
}
