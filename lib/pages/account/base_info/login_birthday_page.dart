import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/win_media.dart';
import 'package:pinput/pinput.dart';

class LoginBirthdayPage extends StatefulWidget {
  const LoginBirthdayPage({Key? key}) : super(key: key);

  @override
  _LoginBirthdayPageState createState() => _LoginBirthdayPageState();
}

class _LoginBirthdayPageState extends State<LoginBirthdayPage> {
  final TextEditingController _textController = TextEditingController();
  String phoneInputValue = '';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    final user = await SharedUtil.getString(SPKeys.account);

    print(user);
    // _unameController.text = Global.profile.lastLoginBirthday ?? "";
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

  void _showDatePicker() {
    DateTime current = DateTime.now();

    Pickers.showDatePicker(
      context,
      mode: DateMode.YMD,
      suffix: Suffix.normal(),
      selectDate: phoneInputValue.isNotEmpty ?
        PDuration(year: int.tryParse(phoneInputValue.split('-').elementAt(0)), month: int.tryParse(phoneInputValue.split('-').elementAt(1)), day: int.tryParse(phoneInputValue.split('-').elementAt(2))) :
        PDuration(year: 1990, month: 6, day: 15),
      minDate: PDuration(year: current.year - 80, month: 1, day: 1),
      maxDate: PDuration(year: current.year - 10, month: current.month, day: current.day),

      // selectDate: PDuration(hour: 18, minute: 36, second: 36),
      // minDate: PDuration(hour: 12, minute: 38, second: 3),
      // maxDate: PDuration(hour: 12, minute: 40, second: 36),
      onConfirm: (p) {
        print('longer >>> 返回数据：$p');
        setState(() {
          print('showDatePicker=======${p.year}-${p.month}-${p.day}');
          _textController.setText(phoneInputValue = '${p.year}-${p.month}-${p.day}');
        });
      },
      // onChanged: (p) => print(p),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerRight,
          child: const Text(
            '2/5',
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
                        '选择你的生日',
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
                        '爱园社交软件遵循极高隐私原则，他人不会看到你的生日信息。',
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
                                      placeholder: "请选择你的生日",
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
                                Positioned(
                                  child: GestureDetector(
                                    onTap: () async {
                                      _showDatePicker();
                                    },
                                    child: Container(
                                      color: ThemeColors.mainGrayBackground.withOpacity(0.001),
                                      width: winWidth(context) - 100,
                                      height: 70,
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
                      text: '下一步',
                      width: winWidth(context) - 100,
                      height: 50,
                      fontSize: 18,
                      theme: phoneInputValue.isNotEmpty ? ButtonMain.themeConfirm : ButtonMain.themeDisabled,
                      onPressed: (text) {
                        if (phoneInputValue.isNotEmpty) {
                          RouteUtil.push(context, RoutePath.loginSexPage);
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
