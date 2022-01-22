import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageService {
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadPicture(File image, String id) async {
    try {
      firebase_storage.Reference reference = _storage.ref("users/$id.jpg");
      await reference.putFile(image);
      return reference.getDownloadURL();
    } catch (e) {
      print("Something went wrong");
    }
  }

  Future<String?> downloadUrl(String userId) async {
    return await _storage.ref('/users/$userId.jpg').getDownloadURL();
  }
}
