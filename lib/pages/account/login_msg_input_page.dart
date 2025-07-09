import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/provider/global_model.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/toast.dart';
import 'package:gardener/util/win_media.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class LoginMsgInputPage extends StatefulWidget {
  const LoginMsgInputPage({Key? key}) : super(key: key);

  @override
  State<LoginMsgInputPage> createState() => _LoginMsgInputPageState();
}

class _LoginMsgInputPageState extends State<LoginMsgInputPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  int _msgSendTimeCount = 60;
  Timer? _timer;
  String validateMsg = '';

  //倒计时
  void startCountDown() {
     // 重新计时的时候要把之前的清除掉
     if (_timer != null) {
      if (_timer?.isActive ?? false) {
       _timer?.cancel();
       _timer = null;
      }
     }

     const repeatPeriod = Duration(seconds: 1);
     _timer = Timer.periodic(repeatPeriod, (timer) {
      if (_msgSendTimeCount <= 0) {
       timer.cancel();
       return;
      }
       setState(() {
         _msgSendTimeCount--;
       });
     });
     setState(() {
       _msgSendTimeCount = 60;
     });
    }
  
  @override
  void initState() {
    super.initState();
    startCountDown();
  }
  
  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
    if (_timer != null) {
      if (_timer?.isActive ?? false) {
        _timer?.cancel();
        _timer = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context)..setContext(context);

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(70, 69, 66, 1),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.mainGrayBackground,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: ThemeColors.mainGrayBackground),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: FractionallySizedBox(
          widthFactor: 1,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Container(
                  child: const Text(
                    '输入验证码',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: winWidth(context) - 100,
                  margin: const EdgeInsets.only(top: 10, bottom: 80),
                  child: const Text(
                    '验证码已发送至 +86 13739186162',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeColors.mainGray,
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  child: Pinput(
                    autofocus: true,
                    controller: pinController,
                    focusNode: focusNode,
                    androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    separator: const SizedBox(width: 16),
                    validator: (value) {
                      print('validator=======');
                      if ((value?.length ?? 0) == 0) {
                        return validateMsg = '请输入验证码';
                      }
                      else if ((value?.length ?? 0) < 4) {
                        return validateMsg = '请输入4位验证码';
                      }
                      else if(validateMsg.isNotEmpty) {
                        return validateMsg;
                      }
                      return null;
                    },
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                            offset: Offset(0, 3),
                            blurRadius: 16,
                          )
                        ],
                      ),
                    ),
                    onClipboardFound: (value) {
                      debugPrint('onClipboardFound: $value');
                      pinController.setText(value);
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      print('onCompleted:: $pin $validateMsg');
                      validateMsg = '';
                      EasyLoading.show();
                      Future.delayed(const Duration(milliseconds: 1000), (){
                        print('onCompleted 1');
                        EasyLoading.dismiss();
                        if (pinController.value.text != '1111') {
                          print('onCompleted 2');
                          validateMsg = '验证码不正确，请输入1111';
                          focusNode.unfocus();
                          print('onCompleted 3');
                          formKey.currentState?.validate();
                        } else {
                          print('onCompleted 4');
                          /*model.goToLogin = true;
                          model.nickName = '张三';
                          model.avatar = 'true';
                          model.saveUserInfo();*/
                          // RouteUtil.replace(context, RoutePath.mainPage);
                          RouteUtil.push(
                            context,
                            // RoutePath.selectCommunityPage,
                            RoutePath.loginNickNamePage,
                            params: {
                              'operation': 'register'
                            }
                          );
                          Toast.show('账号注册成功，开始录入个人信息', context, type: ToastType.success, duration: 4);
                        }
                      });
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                    cursor: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 21,
                        height: 1,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(137, 146, 160, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: ThemeColors.mainGrayBackground,
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
                _msgSendTimeCount > 0 ?
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: 30,
                    child: Text(
                      '${_msgSendTimeCount}s后可以重新获取',
                      style: const TextStyle(
                          fontSize: 12,
                          color: ThemeColors.mainGray,
                      ),
                    ),
                  ) :
                  TextButton(
                    onPressed: () {
                      print('validate===========');
                      startCountDown();
                    },
                    child: const Text(
                      '重新获取验证码',
                      style: TextStyle(
                        fontSize: 12,
                        color: ThemeColors.mainGray,
                      ),
                    ),
                  ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
