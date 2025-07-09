import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/components/label_row.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/char_info/chat_members.dart';
import 'package:gardener/pages/message/contants_page/common/models.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ActivityInfoSettingsPage extends StatefulWidget {
  const ActivityInfoSettingsPage({Key? key}) : super(key: key);

  @override
  _ActivityInfoSettingsPageState createState() => _ActivityInfoSettingsPageState();

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

class _ActivityInfoSettingsPageState extends State<ActivityInfoSettingsPage> {
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
    return [
      ChatMembers(
        activity: true,
        list: [
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小丸子',
              id: '小丸子'
          ),
          ContactInfo(
              name: '小新',
              id: '小新'
          ),
          ContactInfo(
              name: '小新1',
              id: '小新1'
          ),
        ]
      ),

      LabelRow(
        label: '活动名称',
        rValue: '笑嘻嘻跑步',
        margin: const EdgeInsets.only(top: 10.0),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '活动公告',
        rValue: '笑嘻嘻公告笑嘻嘻公告笑嘻嘻公告笑嘻嘻公告',
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '开始时间',
        rightW: const Text(
          '2023.04.05 10:30',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '结束时间',
        rightW: const Text(
          '2023.04.05 12:30',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '费用形式',
        rightW: const Text(
          'AA',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '费用预计',
        rightW: const Text(
          '50￥/不定/50每人/无',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),

      LabelRow(
        label: '年龄',
        rightW: const Text(
          '25-50岁',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        margin: const EdgeInsets.only(top: 10.0),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '性别',
        rightW: const Text(
          '女/男/不限',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '婚姻',
        rightW: const Text(
          '未婚/已婚',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),


      LabelRow(
        label: '宝宝年龄',
        rightW: const Text(
          '25-50岁',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        margin: const EdgeInsets.only(top: 10.0),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      ),
      LabelRow(
        label: '可携带人数',
        rightW: const Text(
          '1人/不限/无',
          style: TextStyle(
            fontSize: 17.0,
            color: ThemeColors.mainGray,
          ),),
        onPressed: () => { /*routePush(ChatBackgroundPage()) */},
      )
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
    var arguments = ModalRoute.of(context)!.settings.arguments;
    print(arguments);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置活动'),
        actions: [
          Container(
            height: 20,
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
                onPressed: () {
                  EasyLoading.showToast('发起群聊');
                },
                child: const Text('保存')
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: buildChatList(context)
        ),
      ),
    );
  }
}
