import 'package:flutter/material.dart';

import 'easy_image_provider.dart';

/// Convenience provider for a single image
class SingleImageProvider extends EasyImageProvider {
  final Image imageProvider;

  SingleImageProvider(this.imageProvider);

  @override
  Image imageBuilder(BuildContext context, int index) {
    if (index != 0) {
      throw ArgumentError.value(
          initialIndex, 'index', 'The index value must only be 0.');
    }

    return imageProvider;
  }

  @override
  int get imageCount => 1;

  @override
  int get initialIndex => 0;
}
