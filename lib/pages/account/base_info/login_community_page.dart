import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/gardener_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/win_media.dart';
import 'package:pinput/pinput.dart';
import 'package:tapped/tapped.dart';

class LoginCommunityPage extends StatefulWidget {
  const LoginCommunityPage({Key? key}) : super(key: key);

  @override
  _LoginCommunityPageState createState() => _LoginCommunityPageState();
}

class _LoginCommunityPageState extends State<LoginCommunityPage> {
  final TextEditingController _textController = TextEditingController();
  String communityInputValue = '';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    communityInputValue = _textController.text = '上海科技绿洲';
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
          child: const Text(
            '',
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
                        '选择你的社区',
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
                        '爱园是基于你的社区来提供信息服务的软件。',
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
                                    placeholder: "请选择你的社区",
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
                                        communityInputValue = value;
                                      });
                                    }
                                ),
                              ),
                              Positioned(
                                child: GestureDetector(
                                  onTap: () async {
                                    String? community = await RouteUtil.push(
                                      context,
                                      RoutePath.selectCommunityPage,
                                      params: {
                                        'operation': 'register'
                                      }
                                    );
                                    print('community===========$community');
                                    if (community != null) {
                                      setState(() {
                                        _textController.setText(community);
                                        communityInputValue = community;
                                      });
                                    }
                                  },
                                  child: Container(
                                    color: ThemeColors.mainGrayBackground.withOpacity(0.001),
                                    width: winWidth(context) - 100,
                                    height: 70,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Tapped(
                                  onTap: () async {
                                    communityInputValue = _textController.text = '上海科技绿洲2';
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: ThemeColors.mainGrayBackground.withOpacity(0.01),
                                    width: 70,
                                    height: 70,
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 18),
                                      child: const Icon(
                                        GardenerIcons.relocate,
                                        size: 20,
                                        color: ThemeColors.mainGray,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                    ButtonMain(
                      margin: const EdgeInsets.only(top: 40),
                      text: '进入爱园',
                      width: winWidth(context) - 100,
                      height: 50,
                      fontSize: 18,
                      theme: communityInputValue.isNotEmpty ? ButtonMain.themeConfirm : ButtonMain.themeDisabled,
                      onPressed: (text) async {
                        if (communityInputValue.isNotEmpty) {
                          RouteUtil.replace(context, RoutePath.mainPage);
                          await SharedUtil
                              .saveString(SPKeys.community, communityInputValue);
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
