import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String email;
  final String image;
  final Timestamp lastSeen;
  final String name;

  Contact({
    this.email,
    this.id,
    this.image,
    this.lastSeen,
    this.name,
  });

  factory Contact.fromFirestore(dynamic _snapshot) {
    var _data = _snapshot;
    print(_data);
    print('error!!!!!!!!');
    return Contact(
      id: _snapshot.id,
      lastSeen: _data['lastSeen'],
      email: _data['email'],
      name: _data['name'],
      image: _data['image'],
    );
  }
}
