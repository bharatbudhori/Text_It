import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaService {
  static MediaService instance = MediaService();

  Future<File> getIamgeFromLibrary(String type) async {
    if (type == 'camera') {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);

      return File(pickedFile.path);
    } else if (type == 'gallery') {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      return File(pickedFile.path);
    } else
      return null;
  }
}
