import 'package:flutter/material.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/style/style.dart';

class SelectText extends StatelessWidget {
  const SelectText({
    Key? key,
    this.isSelect: true,
    this.title,
  }) : super(key: key);

  final bool isSelect;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.black.withOpacity(0),
      child: Text(
        title ?? '??',
        textAlign: TextAlign.center,
        style:
            isSelect ? StandardTextStyle.big : StandardTextStyle.bigWithOpacity,
      ),
    );
  }
}
