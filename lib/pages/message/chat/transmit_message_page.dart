import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/message/message_normal.dart';
import 'package:ndialog/ndialog.dart';

import '../message_page.dart';
import '/routes/generate_route.dart';
import 'message_item.dart';

class TransmitMessagePage extends StatefulWidget {
  @override
  _TransmitMessageState createState() => _TransmitMessageState();
}


class _TransmitMessageState extends State<TransmitMessagePage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ChatMessageItemState> mMessageItemKey = GlobalKey();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: const Text(
            '选择一个聊天转发',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          elevation: 0,
          centerTitle: true,
        )
      ),
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.white,
      body: MessagePage(
        isTransmit: true,
        onSelected: (id) {
          print('=======================');
          HrlMessage message = RouteUtil.getParams(context) as HrlMessage;
          print(message);
          NDialog(
            dialogStyle: DialogStyle(titleDivider: true),
            title: const Text(
              "发送给：",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
            content: SizedBox(
              height: 140 + ( message.isText() && ((message as HrlTextMessage).text ?? '').length >= 26 ? 20 : 0) + (message.isImage() || message.isVideo() ? 54 : 0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(right: 15),
                        child: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg"),
                          radius: 20.0,
                        ),
                      ),
                      Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        // margin: const EdgeInsets.only(left: 15, right: 15),
                        child: const Text(
                          "测试号0011",
                          style: TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                      ),

                    ],
                  ),
                  Container(
                    alignment: (message.isImage() || message.isVideo() ? Alignment.center : Alignment.centerLeft),
                    child: ChatMessageItem(
                      key: mMessageItemKey,
                      isOnlyQuote: true,
                      mMessage: message,
                      onTap: (String value) {  },
                      onQuoteSelected: (HrlMessage message) {  },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.topLeft,
                    child: const CupertinoTextField(
                      placeholder: '留言',
                      cursorHeight: 22,
                      style: TextStyle(height: 1.3),
                      /*decoration: InputDecoration(
                          labelText: "留言"
                      ),*/
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "取消",
                  style: TextStyle(
                    color: ThemeColors.mainGray
                  ),
                ),
                onPressed: () => Navigator.pop(context)),
              TextButton(
                child: const Text(
                  "发送",
                  style: TextStyle(
                      color: ThemeColors.main
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  EasyLoading.showToast('已发送');
                }
              ),
            ],
          ).show(context);
        }
      )
    );

  }
}