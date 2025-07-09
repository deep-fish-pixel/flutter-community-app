import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/themes.dart';

class ButtonMain extends StatelessWidget{
  static ButtonStyle getConfirmButtonStyle({
    double fontSize = 12.0,
    Color? backgroundColor
  }){
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? ThemeColors.main),                //背景颜色
        foregroundColor: MaterialStateProperty.all(Colors.white),                //字体颜色
        // overlayColor: MaterialStateProperty.all(Colors.amber),                   // 高亮色
        // shadowColor: MaterialStateProperty.all( Color(0xffffffff)),                  //阴影颜色
        elevation: MaterialStateProperty.all(0),                                     //阴影值
        textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: fontSize,
            color: ThemeColors.main
        )),             //字体
        side: MaterialStateProperty.all(const BorderSide(
            width: 1,
            color: Color(0x00C7C7C7)
        )
        ),//边框
        shape: MaterialStateProperty.all(
            const StadiumBorder(
                side: BorderSide(
                  //设置 界面效果
                  style: BorderStyle.solid,
                  color: Color(0xffFF7F24),
                )
            )
        ),
        padding: MaterialStateProperty.all(EdgeInsets.all(0)),

    );
  }

  static ButtonStyle getGrayConfirmButtonStyle({
    double fontSize = 12.0,
    Color? backgroundColor
  }){
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backgroundColor ?? ThemeColors.mainGrayBackground),                //背景颜色
      foregroundColor: MaterialStateProperty.all(Colors.white),                //字体颜色
      // overlayColor: MaterialStateProperty.all(Colors.amber),                   // 高亮色
      // shadowColor: MaterialStateProperty.all( Color(0xffffffff)),                  //阴影颜色
      elevation: MaterialStateProperty.all(0),                                     //阴影值
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: fontSize,
          color: ThemeColors.main
      )),             //字体
      side: MaterialStateProperty.all(const BorderSide(
          width: 1,
          color: Color(0x00C7C7C7)
      )
      ),//边框
      shape: MaterialStateProperty.all(
          const StadiumBorder(
              side: BorderSide(
                //设置 界面效果
                style: BorderStyle.solid,
                color: Color(0xffFF7F24),
              )
          )
      ),
      padding: MaterialStateProperty.all(EdgeInsets.all(0)),

    );
  }

  static ButtonStyle getDisabledButtonStyle({
    double fontSize = 12.0,
    Color? backgroundColor
  }){
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backgroundColor ?? ThemeColors.mainGrayOverlay),                //背景颜色
      foregroundColor: MaterialStateProperty.all(Colors.white),                //字体颜色
      overlayColor: MaterialStateProperty.all(Colors.transparent),                   // 高亮色
      elevation: MaterialStateProperty.all(0),                                     //阴影值
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: fontSize,
          color: ThemeColors.main
      )),             //字体
      side: MaterialStateProperty.all(const BorderSide(
          width: 1,
          color: Color(0x00C7C7C7)
      )
      ),//边框
      shape: MaterialStateProperty.all(
          const StadiumBorder(
              side: BorderSide(
                //设置 界面效果
                style: BorderStyle.solid,
                color: Color(0xffFF7F24),
              )
          )
      ),
      padding: MaterialStateProperty.all(EdgeInsets.all(0)),

    );
  }


  static ButtonStyle getLineButtonStyle({
    double fontSize = 12.0,
    Color? backgroundColor
  }){
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backgroundColor ?? Colors.white),                //背景颜色
      foregroundColor: MaterialStateProperty.all(ThemeColors.main),              //字体颜色
      overlayColor: MaterialStateProperty.all(Color(0x60FF7F24)),                   // 高亮色
      shadowColor: MaterialStateProperty.all( Color(0xffffffff)),                   //阴影颜色
      elevation: MaterialStateProperty.all(0),                                     //阴影值
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: fontSize,
          color: ThemeColors.main
      )),              //字体
      side: MaterialStateProperty.all(const BorderSide(
          width: 1,
          color: ThemeColors.main
      )),//边框
      shape: MaterialStateProperty.all(
          const StadiumBorder(
              side: BorderSide(
                //设置 界面效果
                style: BorderStyle.solid,
                color: ThemeColors.main,
              )
          )
      ),//圆角弧度
    );
  }

  static ButtonStyle getCancelButtonStyle({
    double fontSize = 12.0,
    Color? backgroundColor
  }){
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),                //背景颜色
        foregroundColor: MaterialStateProperty.all(backgroundColor ?? ThemeColors.mainGray),                //字体颜色
        overlayColor: MaterialStateProperty.all(ThemeColors.mainGrayOverlay),                   // 高亮色
        // shadowColor: MaterialStateProperty.all( Color(0xffffffff)),                  //阴影颜色
        elevation: MaterialStateProperty.all(0),                                     //阴影值
        textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: fontSize,
            color: ThemeColors.main
        )),             //字体
        side: MaterialStateProperty.all(const BorderSide(
            width: 1,
            color: ThemeColors.mainGray
        )
        ),//边框
        shape: MaterialStateProperty.all(
            const StadiumBorder(
                side: BorderSide(
                  //设置 界面效果
                  style: BorderStyle.solid,
                  color: Color(0xffFF7F24),
                )
            )
        )
    );
  }

  static const String themeConfirm = 'confirm';
  static const String themeCancel = 'cancel';
  static const String themeLine = 'line';
  static const String themeDisabled = 'disabled';
  static const String themeGreyConfirm = 'greyConfirm';

  final String text;
  final String theme;
  final Function(String text) onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final double? width;
  final Color? backgroundColor;
  final EdgeInsets? margin;

  const ButtonMain({
    Key? key,
    required this.text,
    required this.onPressed,
    this.theme = 'confirm',
    this.fontSize = 12,
    this.fontWeight = FontWeight.normal,
    this.height = 26,
    this.width,
    this.margin,
    this.backgroundColor,
  }) : super(key: key);

  getButtonStyle(){
    switch(theme) {
      case themeConfirm:
        return getConfirmButtonStyle(fontSize: fontSize, backgroundColor: backgroundColor);
      case themeDisabled:
        return getDisabledButtonStyle(fontSize: fontSize, backgroundColor: backgroundColor);
      case themeGreyConfirm:
        return getGrayConfirmButtonStyle(fontSize: fontSize, backgroundColor: backgroundColor);
      case themeLine:
        return getLineButtonStyle(fontSize: fontSize, backgroundColor: backgroundColor);
      case themeCancel:
        return getCancelButtonStyle(fontSize: fontSize, backgroundColor: backgroundColor);
    }
    return getConfirmButtonStyle();
  }

  getTextStyle(){
    switch(theme) {
      case themeConfirm:
      case themeDisabled:
      case themeLine:
      case themeCancel:
        return TextStyle(
            height: 1.2,
            fontWeight: fontWeight,
        );
      case themeGreyConfirm:
        return TextStyle(
          height: 1.2,
          fontWeight: fontWeight,
          color: ThemeColors.mainBlack
        );
    }
    return getConfirmButtonStyle();
  }




  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width ?? null,
        margin: margin,
        child: ElevatedButton(
          style: getButtonStyle(),
          onPressed: () {
            if (theme != themeDisabled) {
              print('123');
              onPressed(text);
            }
          },
          child: Text(
            text,
            style: getTextStyle(),
          ),
        )
    );
  }

}

