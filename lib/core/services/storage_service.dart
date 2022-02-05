import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

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

  Future<String?> getDpPath(String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');

    if (!file.existsSync()) {
      return null;
    }

    return file.path;
  }

  Future<String?> downloadDp(String userId) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$userId');

    try {
      file.create(recursive: true);
      await _storage.ref('/users/$userId.jpg').writeToFile(file);
      return file.path;
    } catch (e) {
      await file.delete(recursive: true);
      throw 'download-failed';
    }
  }

  Future<bool> isDpCached(String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    return file.existsSync();
  }
}
