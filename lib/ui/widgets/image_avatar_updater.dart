import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/core/utils/image_picker.dart';

class ImageUpdater extends StatelessWidget {
  final Function(String?)? onChange;
  final String? url;
  final String? path;
  final String? name;

  const ImageUpdater({Key? key, this.onChange, this.url, this.path, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        height: 100,
        width: 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
          image: path == null
              ? url != null && url != "null"
                  ? DecorationImage(image: CachedNetworkImageProvider(url!))
                  : null
              : DecorationImage(image: FileImage(File(path!))),
        ),
        child: IconButton(
            onPressed: () async {
              String? newPath = await CustomImagePicker.selectImage(context);
              if (newPath != null) {
                onChange!(newPath);
              }
            },
            icon: const Icon(Icons.camera_alt_outlined)),
        alignment: Alignment.center,
      ),
    );
  }
}
