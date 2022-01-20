import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker {
  final BuildContext context;

  CustomImagePicker(this.context);

  //Pick Image
  static Future<String?> selectImage(BuildContext context) async {
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile? imageFile = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (imageFile == null) {
      return null;
    } else {
      return imageFile.path;
    }
  }
}
