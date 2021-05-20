import 'dart:async';

import 'package:chati_fy/models/contact.dart';
import 'package:chati_fy/models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static DBService instance = DBService();

  FirebaseFirestore _db;

  DBService() {
    _db = FirebaseFirestore.instance;
  }
  String _userCollection = 'Users';

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
}
