import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/components/label_row.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/contants_page/common/models.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:gardener/util/dialog/confirm_alert.dart';
import 'package:ndialog/ndialog.dart';
import 'package:toast/toast.dart';

import '../contants_page/activity/activity_info.dart';
import 'chat_members.dart';

class ChatInfoPage extends StatefulWidget {
  const ChatInfoPage({Key? key}) : super(key: key);

  @override
  _ChatInfoPageState createState() => _ChatInfoPageState();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    //获取路由参数
    var args=ModalRoute.of(context)?.settings.arguments;
    print('===================111');
    print(args);
    return Text('123123123');
  }
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  var model;

  bool isTop = false;
  bool isDoNotDisturb = false;

  Widget buildSwitch(item) {
    return LabelRow(
      label: item['label'],
      margin: item['label'] == '置顶聊天' ? EdgeInsets.only(top: 10.0) : null,
      isLine: item['label'] != '屏蔽消息',
      isRight: false,
      rightW: SizedBox(
        height: 25.0,
        child: CupertinoSwitch(
          value: item['value'],
          onChanged: (v) {
            setState(() {
              switch(item['label']) {
                case '置顶聊天':
                  isTop = !isTop;
                  break;
                case '屏蔽消息':
                  isDoNotDisturb = !isDoNotDisturb;
                  break;
              }
            });
          },
        ),
      ),
      onPressed: () {
        setState(() {
          switch(item['label']) {
            case '置顶聊天':
              isTop = !isTop;
              break;
            case '屏蔽消息':
              isDoNotDisturb = !isDoNotDisturb;
              break;
          }
        });
      },
    );
  }

  List<Widget> buildChatList(BuildContext context) {
    var params = RouteUtil.getParams(context) ?? {};
    print('params=======$params');

    List switchItems = [
      {"label": '置顶聊天', 'value': isTop},
      {"label": '屏蔽消息', 'value': isDoNotDisturb},
    ];

    return [
      ChatMembers(
        list: [
          ContactInfo(
            name: '小丸子',
            id: '小丸子'
          ),
          ContactInfo(
            name: '小新',
            id: '小新'
          )
        ]
      ),
      /*LabelRow(
        label: '查找聊天记录',
        margin: EdgeInsets.only(top: 10.0),
        onPressed: () => routePush(SearchPage()),
      ),*/
      LabelRow(
        label: params['activity'] ? '活动名称' : '群名称',
        rightW: Text(
          params['name'],
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        margin: const EdgeInsets.only(top: 10.0),
        onPressed: () {
          if (params['activity']) {
            RouteUtil.push(context, RoutePath.activityInfoPage);
          }
        },
      ),
      LabelRow(
        label: params['activity'] ? '活动公告' : '群公告',
        rightW: const Text(
          '笑嘻嘻业主群',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),

      LabelRow(
        label: '设置当前聊天背景',
        margin: const EdgeInsets.only(top: 10.0, bottom: 10),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      Column(
        children: switchItems.map(buildSwitch).toList(),
      ),
      LabelRow(
        label: '清空聊天记录',
        margin: const EdgeInsets.only(top: 10.0),
        onPressed: () {
          print('onPressed');
          /*confirmAlert(
            context,
            (isOK) {
              if (isOK) EasyLoading.showToast('清空完成');
            },
            tips: '确定删除聊天记录吗？',
            okBtn: '清空',
          );*/
          CupertinoAlertDialog(
            title: const Text("清空聊天记录"),
            content: Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                "确定删除聊天记录吗",
                style: TextStyle(
                    height: 2
                ),
              ),
            ),
            actions: <Widget>[
              CupertinoButton(
                  child: const Text(
                    "取消",
                    style: TextStyle(
                      color: ThemeColors.mainGray,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context)),
              CupertinoButton(
                child: const Text("确定"),
                onPressed: () {
                  EasyLoading.showToast('清空完成', duration: const Duration(seconds: 1));
                  Navigator.pop(context);
                }
              ),
            ],
          ).show(context);
        },
      ),
      LabelRow(
        label: '投诉',
        onPressed: () => {
          RouteUtil.push(context, RoutePath.chatReportPage)
        },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    /*final info = await getUsersProfile([widget.id]);
    List infoList = json.decode(info);
    setState(() {
      if (Platform.isIOS) {
        model = IPersonInfoEntity.fromJson(infoList[0]);
      } else {
        model = PersonInfoEntity.fromJson(infoList[0]);
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    var params = RouteUtil.getParams(context) ?? {};
    print('params=======$params');

    return Scaffold(
      appBar: AppBar(
        title: Text('聊天信息'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: buildChatList(context)
        ),
      ),
    );
  }
}
