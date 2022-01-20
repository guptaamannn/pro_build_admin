import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double? radius;

  const ImageAvatar({Key? key, this.imageUrl, this.name, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl.toString(),
              height: radius == null ? 40 : radius! * 2,
              width: radius == null ? 40 : radius! * 2,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) =>
                  CircularProgressIndicator(
                value: progress.progress,
              ),
            )
          : CircleAvatar(
              child: Text(name!.split(" ")[0][0] + name!.split(" ")[1][0]),
              radius: radius,
            ),
    );
  }
}
