import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/toast.dart';
import 'package:gardener/util/win_media.dart';

class LoginMsgPage extends StatefulWidget {
  const LoginMsgPage({Key? key}) : super(key: key);

  @override
  _LoginMsgPageState createState() => _LoginMsgPageState();
}

class _LoginMsgPageState extends State<LoginMsgPage> {
  final TextEditingController _tC = TextEditingController();
  String phoneInputValue = '';

  @override
  void initState() {
    super.initState();
    getUser();
    // getPhoneNumber();
  }

  getUser() async {
    final user = await SharedUtil.getString(SPKeys.account);

    print(user);
    // _unameController.text = Global.profile.lastLoginMsg ?? "";
    _tC.text = user ?? '';
  }

  Widget bottomItem(item) {
    return Row(
      children: <Widget>[
        InkWell(
          child: Text(item, ),
          onTap: () {

          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 10,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child: const Text(
                        '登录/注册',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    Container(
                      width: winWidth(context) - 100,
                      margin: const EdgeInsets.only(top: 4, bottom: 26),
                      child: const Text(
                        '为营造良好的社区发言氛围，应国家法律要求，进入社区前请先绑定手机号码',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.mainGray,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50.0,
                          width: winWidth(context) - 100,
                          child: CupertinoTextField(
                              keyboardType: TextInputType.phone,
                              autofocus: true,
                              maxLength: 11,
                              placeholder: "请输入手机号码",
                              cursorHeight: 26.0,
                              prefix: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      child: const Text(
                                        '+86',
                                        style: TextStyle(
                                            color: ThemeColors.mainGray
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      margin: const EdgeInsets.only(left: 10,right: 6),
                                      decoration: BoxDecoration(
                                          border: Border(left: BorderSide(width: 0.3, color: Colors.grey.shade600),)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(46),
                                color: ThemeColors.mainGrayBitBackground,
                              ),
                              onChanged: (value){
                                print(value);
                                setState(() {
                                  phoneInputValue = value;
                                });
                              }
                          ),
                        ),
                      ],
                    ),
                    ButtonMain(
                      margin: const EdgeInsets.only(top: 40),
                      text: '下一步',
                      width: winWidth(context) - 100,
                      height: 50,
                      fontSize: 18,
                      theme: phoneInputValue.length > 0 ? ButtonMain.themeConfirm : ButtonMain.themeDisabled,
                      onPressed: (text) {
                        if (phoneInputValue.length < 11) {
                          Toast.show('手机号长度必须是11位', context);
                        } else if (!RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$')
                            .hasMatch(phoneInputValue)) {
                          Toast.show('手机号码不存在', context);
                        } else {
                          RouteUtil.push(context, RoutePath.loginMsgInputPage);
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
