import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/components/ui.dart';
import 'package:gardener/constants/themes.dart';

import '../pages/message/char_info/image_view.dart';
import '../util/win_media.dart';


class ListTileView extends StatelessWidget {
  final BoxBorder? border;
  final VoidCallback? onPressed;
  final String? title;
  final String? label;
  final Icon? icon;
  final double width;
  final double horizontal;
  final TextStyle titleStyle;
  final bool isLabel;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxFit? fit;

  ListTileView({
    this.border,
    this.onPressed,
    this.title,
    this.label,
    this.padding = const EdgeInsets.symmetric(vertical: 15.0),
    this.isLabel = true,
    this.icon,
    this.titleStyle =
        const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    this.margin,
    this.fit,
    this.width = 45.0,
    this.horizontal = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    var text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title ?? '', style: titleStyle),
        Text(
          label ?? '',
          style: TextStyle(color: ThemeColors.mainBlack, fontSize: 12),
        ),
      ],
    );

    var view = [
      isLabel ? text : Text(title!, style: titleStyle),
      Spacer(),
      Container(
        width: 7.0,
        child: true
            ? Icon(CupertinoIcons.right_chevron,
            color: ThemeColors.mainGray.withOpacity(0.5))
            : Container(width: 10.0),
      ),
      Space(),
    ];

    var row = Row(
      children: <Widget>[
        icon == null ? Container() : Container(
          width: width - 5,
          margin: EdgeInsets.symmetric(horizontal: horizontal),
          child: icon,
        ),
        Container(
          width: winWidth(context) - 60,
          padding: padding,
          decoration: BoxDecoration(border: border),
          child: Row(children: view),
        ),
      ],
    );

    return Container(
      margin: margin,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0))
        ),
        onPressed: onPressed ?? () {},
        child: row,
      ),
    );
  }
}
