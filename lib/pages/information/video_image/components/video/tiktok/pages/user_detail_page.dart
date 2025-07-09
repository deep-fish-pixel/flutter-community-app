import 'package:flutter/material.dart';
import 'package:gardener/components/label_row.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/style/style.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:tapped/tapped.dart';
import '../views/tiltok_app_bar.dart';



class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人信息"),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: buildChatList(context)
        ),
      ),
    );
  }

  List<Widget> buildChatList(BuildContext context) {
    List switchItems = [];

    return [
      LabelRow(
        label: '头像',
        margin: const EdgeInsets.only(top: 10.0),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '背景图',
        margin: const EdgeInsets.only(bottom: 10),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '昵称',
        rightW: const Text(
          '天枢古诗小能手',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),
        ),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '简介',
        rightW: const Text(
          '健身爱好者',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),
        ),
        margin: const EdgeInsets.only(bottom: 10.0),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '手机号',
        onPressed: () => {
        },
      ),
      LabelRow(
        label: '年龄',
        onPressed: () => {
        },
      ),
      LabelRow(
        label: '性别',
        margin: const EdgeInsets.only(bottom: 10.0),
        onPressed: () => {
        },
      ),
      LabelRow(
        label: '婚姻',
        onPressed: () => {
        },
      ),
      LabelRow(
        label: '子女',
        onPressed: () => {
        },
      ),
    ];
  }
}

class _UserInfoRow extends StatelessWidget {
  _UserInfoRow({
    this.icon,
    this.title,
    this.rightIcon,
    this.onTap,
  });
  final Widget? icon;
  final Widget? rightIcon;
  final String? title;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    Widget iconImg = Container(
      height: 24,
      width: 24,
      child: icon,
    );

    Widget row = Container(
      height: 48,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border(
          bottom: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        children: <Widget>[
          icon != null ? iconImg : Container(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                title!,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: rightIcon ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
          ),
        ],
      ),
    );
    row = Tapped(
      onTap: onTap,
      child: row,
    );

    return row;
  }
}
