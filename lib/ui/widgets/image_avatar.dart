import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pro_build_attendance/core/viewModel/user_model.dart';
import 'package:pro_build_attendance/locator.dart';

class CachedImageAvatar extends StatelessWidget {
  final String fileName;
  final String? name;
  final double? radius;
  final bool? hasDp;

  CachedImageAvatar(
      {Key? key, required this.fileName, this.name, this.radius, this.hasDp})
      : super(key: key);

  var model = locator<UserModel>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: hasDp == null
          ? model.getCacheDpPath(fileName)
          : model.downloadUserDp(fileName),
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(name!.split(" ")[0][0] + name!.split(" ")[1][0]),
                CircularProgressIndicator(),
              ],
            ),
          );
        }

        if (snapshot.data == null || snapshot.hasError) {
          return CircleAvatar(
            child: Text(name!.split(" ")[0][0] + name!.split(" ")[1][0]),
          );
        }

        return ClipOval(
            child: Image.file(
          File(snapshot.data!),
          height: radius == null ? 40 : radius! * 2,
          width: radius == null ? 40 : radius! * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print(error);
            return CircleAvatar(
              child: Text(name!.split(" ")[0][0] + name!.split(" ")[1][0]),
              radius: radius,
            );
          },
        ));
      },
    );
  }
}
