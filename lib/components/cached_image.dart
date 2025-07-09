import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/themes.dart';

class CachedImage extends StatelessWidget {
  final String url;

  const CachedImage(this.url, {Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            strokeWidth: 1,
            backgroundColor: ThemeColors.mainGray,
          )
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  static CachedNetworkImageProvider getProvider(String url){
    return CachedNetworkImageProvider(
      url,
    );
  }

}