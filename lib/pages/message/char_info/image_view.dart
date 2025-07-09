import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/constant.dart';
import 'package:gardener/util/check.dart';

class ImageView extends StatelessWidget {
  final String img;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double radius;

  const ImageView({
    required this.img,
    this.height,
    this.width,
    this.fit,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (isNetWorkImg(img)) {
      image = CachedNetworkImage(
        imageUrl: img,
        width: width,
        height: height,
        fit: fit,
        cacheManager: Constant.cacheManager,
      );
    } else if (File(img).existsSync()) {
      image = Image.file(
        File(img),
        width: width,
        height: height,
        fit: fit,
      );
    } else if (isAssetsImg(img)) {
      image = Image.asset(
        img,
        width: width,
        height: height,
        fit: width != null && height != null ? BoxFit.fill : fit,
      );
    } else {
      image = Container(
        /*decoration: BoxDecoration(
          color: Colors.black26.withOpacity(0.1),
          border: Border.all(color: Colors.black.withOpacity(0.2),width: 0.3)
        ),*/
        child: Image.asset(
          'assets/images/def_avatar.png',
          width: width! - 1,
          height: height! - 1,
          fit: width != null && height != null ? BoxFit.fill : fit,
        ),
      );
    }
    if (radius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.all(
            Radius.circular(radius)
        ),
        child: image,
      );
    }
    return image;
  }
}
