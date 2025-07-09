import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/components/pop_up_menu.dart';
import 'package:gardener/constants/themes.dart';
import 'contants_page/contacts_page.dart';
import 'message_page.dart';

class MessageMainPage extends StatefulWidget {
  const MessageMainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    print('=========================MessageMainPage');
    return MessageMainState();
  }
}

class MessageMainState extends State<MessageMainPage>
    with SingleTickerProviderStateMixin {
  // 存放各个可选项的数组
  List<String> tabs = [
    '消息',
    '通讯录',
  ];
  // 创建切换控制器
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      print("_tabController.index的值:${_tabController.index}");
      setState(() {
        print("_tabController.index的值:${_tabController.index}");
      });
    });
  }

  //当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(top: 30),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: const Color(0xffFF3700),
                      indicator: const UnderlineTabIndicator(
                          borderSide:
                          BorderSide(color: Color(0xffFF3700), width: 2),
                          insets: EdgeInsets.only(bottom: 7)),
                      labelColor: ThemeColors.mainBlack,
                      unselectedLabelColor: ThemeColors.mainGray,
                      labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                      unselectedLabelStyle: const TextStyle(fontSize: 16.0),
                      indicatorSize: TabBarIndicatorSize.label,
                      controller: _tabController,
                      tabs: tabs.map((name) => Tab(
                        text: name,
                      )).toList(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 0),
                      child: _popupMenuButton(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 40),
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          EasyLoading.showToast('搜索');
                        },
                      ),
                    ),
                  ),
                  /*Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Image.asset("assets/images/message_setting.webp",
                          width: 30.0, height: 30.0),
                      onPressed: () {
                        // Routes .navigateTo(context, '${Routes.weiboPublishPage}');
                      },
                    ),
                  ),*/
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    MessagePage(),
                    ContactsPage()
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  PopupMenu _popupMenuButton(BuildContext context){
    return PopupMenu(
        icon: const Icon(Icons.add_circle_outline),
        menus: [
          PopupMenuModel(value: "111", title: "发起群聊", icon: Icons.chat_bubble),
          PopupMenuModel(value: "222", title: "发起活动", icon: Icons.collections),
          PopupMenuModel(value: "222", title: "添加朋友", icon: Icons.group_add),
        ],
        onSelected: (value) {
          print(value);
        }
    );
  }
}