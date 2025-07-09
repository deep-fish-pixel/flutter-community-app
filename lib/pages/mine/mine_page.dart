import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gardener/models/blog/user_model.dart';

import '../../components/list_tile_view.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  void action(name) {
    switch (name) {
      case '设置':
        break;
      case '支付':
        break;
      default:
        break;
    }
  }

  Widget buildContent(item) {
    return ListTileView(
      border: item['bottomMargin'] == true
          ? null
          : Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      title: item['label'],
      titleStyle: TextStyle(fontSize: 15.0),
      isLabel: false,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      icon: item['icon'],
      margin: EdgeInsets.only(
        top: item['topMargin'] == true ? 10.0 : 0.0,
        bottom: item['bottomMargin'] == true ? 10.0 : 0.0,
      ),
      onPressed: () => action(item['label']),
      width: 25.0,
      fit: BoxFit.cover,
      horizontal: 15.0,
    );
  }

  Widget body(UserModel model) {
    List data = [
      {'label': '作品', 'icon': 'assets/images/mine/ic_pay.png', 'topMargin': true},
      {'label': '收藏', 'icon': 'assets/images/mine/ic_pay.png', 'bottomMargin': true},
      {'label': '点赞', 'icon': 'assets/images/favorite.webp'},
      {'label': '活动', 'icon': 'assets/images/mine/ic_card_package.png', 'bottomMargin': true},
      {'label': '贵族', 'icon': 'assets/images/mine/ic_card_package.png'},
      {'label': '认证', 'icon': 'assets/images/mine/ic_emoji.png', 'bottomMargin': true},
      {'label': '每日任务', 'icon': 'assets/images/mine/ic_setting.png'},
      {'label': '资产', 'icon': 'assets/images/mine/ic_setting.png', 'bottomMargin': true},
      {'label': '设置', 'icon': 'assets/images/mine/ic_setting.png'},
    ];

    var row = [
      SizedBox(
        width: 60.0,
        height: 60.0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Image.asset(model.headPic, fit: BoxFit.cover),
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 15.0),
        height: 60.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              model.nick,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              '微信号：',
            ),
          ],
        ),
      ),
      Spacer(),
      Container(
        width: 13.0,
        margin: EdgeInsets.only(right: 12.0),
        child: Image.asset('assets/images/mine/ic_small_code.png',
            fit: BoxFit.cover),
      ),
      Image.asset('assets/images/ic_right_arrow_grey.webp',
          width: 7.0, fit: BoxFit.cover)
    ];

    return Column(
      children: <Widget>[
        InkWell(
          child: Container(
            color: Colors.white,
            // height: (topBarHeight(context) * 2.5) - 10,
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, children: row),
          ),
          onTap: () => {},
        ),
        Column(children: data.map(buildContent).toList()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final model = Provider.of<UserModel>(context);
    final model = UserModel(
      id: '123',
      nick: '123',
      headPic: ''
    );
    return Container(
      child: SingleChildScrollView(child: body(model)),
    );
  }
}
