import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/provider/ui_provider.dart';
import 'package:pro_build_attendance/services/firestore_service.dart';
import 'package:pro_build_attendance/services/storage_service.dart';
import 'package:provider/provider.dart';

class UserEditModel {
  final BuildContext context;
  final Firestore _firestore = Firestore();
  final StorageService _storageService = StorageService();
  UserEditModel(this.context);

  Future<void> updateUserInfo({required User user, String? dp}) async {
    context.read<Ui>().setLoading();
    if (dp != null) {
      String? imageUrl = await _storageService.uploadPicture(File(dp), user.id);
      user.dpUrl = imageUrl;
    }

    await _firestore.updateUserInfo(user.id, user.toJson());
    context.read<Ui>().setLoading();
  }
}
