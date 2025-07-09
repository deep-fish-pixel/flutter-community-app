import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../constants/themes.dart';

class LabelRow extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? labelWidth;
  final bool isRight;
  final bool isLine;
  final String? value;
  final String? rValue;
  final Widget? rightW;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? headW;
  final double lineWidth;

  const LabelRow({
    super.key,
    required this.label,
    required this.onPressed,
    this.value,
    this.labelWidth,
    this.isRight = true,
    this.isLine = false,
    this.rightW,
    this.rValue,
    this.margin,
    this.padding = const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 5.0),
    this.headW,
    this.lineWidth = ThemeWidthes.mainLineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
          overlayColor: MaterialStateProperty.all(const Color(0x6faaaaaa)),
    ),
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          }
        },
        child: Container(
          padding: padding,
          margin: EdgeInsets.only(left: 20.0),
          decoration: BoxDecoration(
            border: isLine
                ? Border(bottom: BorderSide(color: Colors.grey, width: lineWidth))
                : null,
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              headW ?? Container(),
              SizedBox(
                width: labelWidth,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17.0,
                    color: ThemeColors.mainBlack,
                  ),
                ),
              ),
              value != null
                  ? Text(value!,
                      style: TextStyle(
                        color: ThemeColors.mainGray.withOpacity(0.7),
                      ))
                  : Container(),
              Spacer(),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: rValue != null ? Text(
                      rValue!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ThemeColors.mainGray,
                      )
                  ) : Container(
                    child: rightW,
                  ) ?? Container(),
                ),
              ),
              isRight
                  ? Icon(CupertinoIcons.right_chevron,
                      color: ThemeColors.mainGray.withOpacity(0.5))
                  : Container(width: 10.0)
            ],
          ),
        ),
      ),
    );
  }
}
