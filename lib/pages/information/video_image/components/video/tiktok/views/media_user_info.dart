import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/information/video_image/components/style/style.dart';
import 'package:gardener/util/win_media.dart';

class MediaUserInfo extends StatefulWidget {
  final double bottomPadding;
  final String? desc;
  final String descTest = '朱二旦的枯燥生活，广东省湛江市，一名男子驾驶小轿车与朋友一起到洗车店里洗车。可正当洗车设备快要到达车辆中部时，坐在副驾驶位置的朋友突然打开车门，由于躲闪不及，该驾驶员的朋友瞬间被卷入自动洗车设备中，其手臂也被设备挤压。所幸工作人员发现及时，并快速关停了洗车设备，这才避免了一场事故的发生';
  const MediaUserInfo({
    Key? key,
    required this.bottomPadding,
    // @required this.onGoodGift,
    this.desc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MediaUserInfoState();
  }

}

class _MediaUserInfoState extends State<MediaUserInfo> {
  bool more = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.only(
        left: 12,
        bottom: widget.bottomPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  // tkController.animateToMiddle();
                },
                child: Container(
                  width: 74,
                  alignment: Alignment.centerLeft,
                  child: Container(
                      width: 54,
                      height: 54,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(54),
                      ),
                      child: const Image(
                        image: NetworkImage('https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp'),
                      )
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  // tkController.animateToMiddle();
                },
                child: Container(
                  // flex: 1,
                  child: Container(
                    height: 30.0,
                    child: const Text(
                      '123456',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: 20,
                ),
                width: 80,
                height: 30,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.only(left: 24, right: 24, bottom: 4)),
                    backgroundColor: MaterialStateProperty.all(ThemeColors.main),                //背景颜色
                    foregroundColor: MaterialStateProperty.all(Color(0xff5E6573)),                //字体颜色
                    overlayColor: MaterialStateProperty.all(Color(0x60FF7F24)),                   // 高亮色
                    shadowColor: MaterialStateProperty.all( Color(0xffffffff)),                   //阴影颜色
                    elevation: MaterialStateProperty.all(0),                                     //阴影值
                    textStyle: MaterialStateProperty.all(const TextStyle(
                        fontSize: 12,
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
                  ),
                  onPressed: () {  },
                  child: const Text(
                    "关注",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: more ? widget.descTest : '${widget.descTest.substring(0, min(widget.descTest.length - 1, (24 / 220  * winWidthFromCache()).floor()))} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SysSize.big,
                      color: Colors.white,
                      inherit: true,
                    ),
                  ),
                  TextSpan(
                    text: more ? ' 收起 ' : ' 更多 ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SysSize.big,
                      color: ThemeColors.mainGray99,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => {
                      setState(() => more = !more)
                    },
                  ),
                ]
              )
          ),
        ],
      ),
    );
  }
}