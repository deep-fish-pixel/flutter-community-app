import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gardener/components/cached_image.dart';
import 'package:gardener/constants/themes.dart';

class MessageVideo extends StatelessWidget {
  // 预览图片地址
  String thumbnailUrl;
  // 视频地址
  String videoUrl;
  // 是否小图
  bool small = false;

  Function(String videoUrl)? onTap;

  MessageVideo({
    Key? key,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.onTap,
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? (){
        onTap!(videoUrl);
      } : null,
      child: Stack(
          alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
          children: <Widget>[
            ClipRRect( //剪裁为圆角矩形
                borderRadius: BorderRadius.circular(5.0),
                child: CachedImage(thumbnailUrl)
            ),
            Positioned(
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    size: small ? 15 : 40,
                    color: Colors.white,
                  ),
                )
            )
          ]
      ),
    );
  }

}


