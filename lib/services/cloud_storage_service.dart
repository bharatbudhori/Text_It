import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  dynamic _storage;
  dynamic _baseRef;

  String _profileImages = 'profile_images';

  CloudStorageService() {
    _storage = FirebaseStorage.instance;
    _baseRef = _storage.ref();
  }

  Future<dynamic> uploadUserImage(String _uid, File _image) {
    try {
      return _baseRef.child(_profileImages).child(_uid).putFile(_image);
    } catch (error) {
      print(error);
    }
  }
}
