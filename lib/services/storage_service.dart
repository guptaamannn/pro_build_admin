import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageService {
  Future<String?> uploadPicture(File image, String id) async {
    try {
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instance.ref("users/$id.jpg");
      await reference.putFile(image);
      return reference.getDownloadURL();
    } catch (e) {
      print("Something went wrong");
    }
  }
}
