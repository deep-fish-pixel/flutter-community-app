import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/win_media.dart';

class LoginMarriagePage extends StatefulWidget {
  const LoginMarriagePage({Key? key}) : super(key: key);

  @override
  _LoginMarriagePageState createState() => _LoginMarriagePageState();
}

class _LoginMarriagePageState extends State<LoginMarriagePage> {
  bool? merried;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerRight,
          child: const Text(
            '4/5',
            style: TextStyle(
                fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child: const Text(
                        '选择你的婚姻情况',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    Container(
                      width: winWidth(context) - 100,
                      margin: const EdgeInsets.only(top: 10, bottom: 36),
                      child: const Text(
                        '爱园社交软件遵循极高隐私原则，他人不会看到你的婚姻信息。',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.mainGray,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              merried = false;
                            });
                          },
                          child: Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            width: winWidth(context) - 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(46),
                              border: Border.all(width: 2, color: merried == false ? ThemeColors.main : ThemeColors.mainGrayBackground),
                              color: ThemeColors.mainGrayBitBackground,
                            ),
                            child: Text(
                              '未婚',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: merried == false ? ThemeColors.main : ThemeColors.mainBlack
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              merried = true;
                            });
                          },
                          child: Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            width: winWidth(context) - 100,
                            margin: const EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(46),
                              border: Border.all(width: 2, color: merried == true ? ThemeColors.main : ThemeColors.mainGrayBackground),
                              color: ThemeColors.mainGrayBitBackground,
                            ),
                            child: Text(
                              '已婚',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: merried == true ? ThemeColors.main : ThemeColors.mainBlack
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    ButtonMain(
                      margin: const EdgeInsets.only(top: 50),
                      text: '下一步',
                      width: winWidth(context) - 100,
                      height: 50,
                      fontSize: 18,
                      theme: merried != null ? ButtonMain.themeConfirm : ButtonMain.themeDisabled,
                      onPressed: (text) {
                        if (merried != null) {
                          Future.delayed(const Duration(milliseconds: 300), (){
                            RouteUtil.push(context, RoutePath.loginCommunityPage);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
