import 'package:flutter/services.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:flutter/material.dart';
import 'package:gardener/provider/global_model.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/toast.dart';
import 'package:gardener/util/win_media.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _tC = TextEditingController();
  bool _checkboxSelected = false;
  String phoneNumber = '初始化';
  String _mobileNumber = '';
  List<SimCard> _simCard = <SimCard>[];

  @override
  void initState() {
    super.initState();
    getUser();
    // getPhoneNumber();
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });

    initMobileNumberState();
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      phoneNumber = 'no permission';
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _mobileNumber = (await MobileNumber.mobileNumber)!;
      _simCard = (await MobileNumber.getSimCards)!;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
      phoneNumber = 'get error';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      phoneNumber = _mobileNumber;
    });
  }

  getUser() async {
    final user = await SharedUtil.getString(SPKeys.account);

    print(user);
    // _unameController.text = Global.profile.lastLogin ?? "";
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

  showActivityConfirm(BuildContext context,
      {
        required void Function() confirm
      }
    ){
    NAlertDialog(
      dismissable: false,
      dialogStyle: DialogStyle(
        contentPadding: const EdgeInsets.all(0),
      ),
      content: SizedBox(
        height: 290,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                '温馨提示',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: ThemeColors.mainBlack
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: winWidth(context) - 120,
              child: Column(
                children: [
                  const Text(
                    '您还未同意以下协议，请仔细阅读并点击下方"同意"进行下一步',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: const Text(
                      '《用户协议》',
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeColors.main,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      '《隐私政策》',
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeColors.main,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      '《中国移动认证服务条款》',
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeColors.main,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20, right: 0),
            width: 150,
            height: 56,
            child: ButtonMain(
              text: '取消',
              theme: ButtonMain.themeCancel,
              onPressed: (String text) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 0, right: 20),
            width: 150,
            height: 56,
            child: ButtonMain(
              text: '同意并继续',
              onPressed: (String text) {
                setState(() {
                  _checkboxSelected = true;
                });
                Navigator.pop(context);
                confirm();
              },
            ),
          ),
        )
      ],
    ).show(context);
  }


  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context)..setContext(context);

    return Material(
        child: SafeArea(
          top: true,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset(
                      'assets/images/login/main.webp'
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            phoneNumber,
                            style: TextStyle(
                                fontSize: 18,
                                color: ThemeColors.mainBlack,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          Container(
                            width: 30,
                            child: IconButton(
                              icon: const Icon(
                                RemixIcons.editLine,
                                color: ThemeColors.main,
                              ),
                              onPressed: () {
                                print('onPressed');
                                if (_checkboxSelected) {
                                  RouteUtil.push(context, RoutePath.loginMsgPage);
                                } else {
                                  showActivityConfirm(
                                      context,
                                      confirm: (){
                                        RouteUtil.push(context, RoutePath.loginMsgPage);
                                      }
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      ButtonMain(
                        margin: const EdgeInsets.only(top: 20),
                        text: '一键登录',
                        width: winWidth(context) - 100,
                        height: 50,
                        fontSize: 18,
                        backgroundColor: ThemeColors.main,
                        onPressed: (value) async {
                          if (_checkboxSelected) {
                            Toast.show('去登录', context);
                            model.goToLogin = true;
                            model.nickName = '张三';
                            model.avatar = 'true';
                            await model.saveUserInfo();
                            // RouteUtil.replace(context, RoutePath.mainPage);
                            Toast.show('登录成功', context);
                            RouteUtil.pop(context);
                          } else {
                            showActivityConfirm(
                                context,
                                confirm: () async {
                                  Toast.show('去登录', context);
                                  model.goToLogin = true;
                                  model.nickName = '张三';
                                  model.avatar = 'true';
                                  await model.saveUserInfo();
                                  // RouteUtil.replace(context, RoutePath.mainPage);
                                  Toast.show('登录成功', context);
                                  RouteUtil.pop(context);
                                }
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  width: winWidth(context) - 100,
                  child: Row(
                    children: [
                      Checkbox(
                        value: _checkboxSelected,
                        activeColor: Colors.red, //选中时的颜色
                        onChanged:(value){
                          setState(() {
                            _checkboxSelected = value!;
                            print(value);
                            print(_checkboxSelected);
                          });
                        } ,
                      ),
                      const Flexible(
                          child: SelectableText.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '我已阅读并同意 ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ThemeColors.mainGray
                                  ),
                                ),
                                TextSpan(
                                  text: '用户协议',
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.wavy,
                                    decorationThickness: 1,
                                    color: ThemeColors.mainBlack,
                                  ),
                                ),
                                TextSpan(
                                  text: ' 、 ',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text: '隐私政策',
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.wavy,
                                    decorationThickness: 1,
                                    color: ThemeColors.mainBlack,
                                  ),
                                ),
                                TextSpan(
                                  text: ' 和 ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ThemeColors.mainGray,
                                  ),
                                ),
                                TextSpan(
                                  text: '中国移动认证服务条款',
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.wavy,
                                    decorationThickness: 1,
                                    color: ThemeColors.mainBlack,
                                  ),
                                )
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}
