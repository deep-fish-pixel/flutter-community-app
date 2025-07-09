import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/win_media.dart';
import 'package:tapped/tapped.dart';

class LoginNickNamePage extends StatefulWidget {
  const LoginNickNamePage({Key? key}) : super(key: key);

  @override
  _LoginNickNamePageState createState() => _LoginNickNamePageState();
}

class _LoginNickNamePageState extends State<LoginNickNamePage> {
  final TextEditingController _textController = TextEditingController();
  FocusNode mFocusNode = FocusNode();
  String phoneInputValue = '';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    final user = await SharedUtil.getString(SPKeys.account);

    print(user);
    // _unameController.text = Global.profile.lastLoginNickName ?? "";
    _textController.text = user ?? '';
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
        title: Container(
          alignment: Alignment.centerRight,
          child: Tapped(
            onTap: () {
              mFocusNode.unfocus();
              RouteUtil.push(context, RoutePath.loginCommunityPage);
            },
            child: const Text(
              '跳过',
              style: TextStyle(
                  fontWeight: FontWeight.w400
              ),
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
                        '添加昵称',
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
                        '昵称用于你的沟通和展示的名称，起个个性化的名称吧！',
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
                            child: Stack(
                              children: [
                                Container(
                                  height: 50,
                                  child: CupertinoTextField(
                                      keyboardType: TextInputType.text,
                                      controller: _textController,
                                      focusNode: mFocusNode,
                                      placeholder: "请输入昵称",
                                      cursorHeight: 26.0,
                                      prefix: Container(
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 30,
                                              margin: const EdgeInsets.only(left: 16,right: 6),
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
                            )
                        ),
                      ],
                    ),
                    ButtonMain(
                      margin: const EdgeInsets.only(top: 40),
                      text: '下一步',
                      width: winWidth(context) - 100,
                      height: 50,
                      fontSize: 18,
                      theme: phoneInputValue.isNotEmpty ? ButtonMain.themeConfirm : ButtonMain.themeDisabled,
                      onPressed: (text) {
                        print('下一步=======');
                        mFocusNode.unfocus();
                        if (phoneInputValue.isNotEmpty) {
                          RouteUtil.push(context, RoutePath.loginCommunityPage);
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
