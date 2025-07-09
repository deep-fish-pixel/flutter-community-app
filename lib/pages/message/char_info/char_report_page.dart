import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'chat_members.dart';

class ChatReportPage extends StatefulWidget {
  const ChatReportPage({Key? key}) : super(key: key);

  @override
  _ChatReportPageState createState() => _ChatReportPageState();
}

class _ChatReportPageState extends State<ChatReportPage> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    print(arguments);

    return Scaffold(
      appBar: AppBar(
        title: Text('举报用户'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('请选择你要举报的类型')
          ]
        ),
      ),
    );
  }
}
