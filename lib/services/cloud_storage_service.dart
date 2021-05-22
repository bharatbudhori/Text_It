import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  dynamic _storage;
  dynamic _baseRef;

  String _profileImages = 'profile_images';
  String _messages = 'messages';
  String _images = 'images';

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

  Future<dynamic> uploadMediaMessage(String _uid, File _file) {
    var timestamp = DateTime.now();
    var _filename = basename(_file.path);
    _filename += '_${timestamp.toString()}';
    try {
      _baseRef
          .child(_messages)
          .child(_uid)
          .child(_images)
          .child(_filename)
          .putFile(_file);
    } catch (error) {
      print('$error  ???????????????????');
    }
  }
}
