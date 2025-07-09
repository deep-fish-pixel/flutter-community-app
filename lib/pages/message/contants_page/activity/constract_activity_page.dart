import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/pop_up_menu.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/contants_page/common/index.dart';
import 'package:gardener/pages/message/contants_page/common/models.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';


class ConstractActivityPage extends StatefulWidget {
  const ConstractActivityPage({Key? key}) : super(key: key);

  @override
  _ConstractActivityPageState createState() => _ConstractActivityPageState();
}

class _ConstractActivityPageState extends State<ConstractActivityPage> {
  List<ContactInfo> contactList = [];
  List<ContactInfo> topList = [];
  bool mineChecked = false;
  bool otherChecked = false;

  @override
  void initState() {
    super.initState();
    topList.add(ContactInfo(
        name: '新的朋友',
        tagIndex: '↑',
        bgColor: Colors.orange,
        iconData: Icons.person_add));
    topList.add(ContactInfo(
        name: '群聊',
        tagIndex: '↑',
        bgColor: Colors.green,
        iconData: Icons.people));
    topList.add(ContactInfo(
        name: '活动',
        tagIndex: '↑',
        bgColor: Colors.blue,
        iconData: Icons.local_offer));
    loadData();
  }

  void loadData() async {
    //加载联系人列表
    rootBundle.loadString('assets/data/car_models.json').then((value) {
      List list = json.decode(value);

      /*setState(() {
        list.forEach((v) {
          contactList.add(ContactInfo.fromJson(v));
        });
      });*/
      setState(() {
        contactList.add(ContactInfo(
            name: '一起跑步',
            tagIndex: '↑',
            bgColor: Colors.orange,
            iconData: Icons.person_add));
        contactList.add(ContactInfo(
            name: '一起露营',
            tagIndex: '↑',
            bgColor: Colors.green,
            iconData: Icons.people));
        contactList.add(ContactInfo(
            name: '一起学习',
            tagIndex: '↑',
            bgColor: Colors.blue,
            iconData: Icons.local_offer));
      });
    });
  }

  PopupMenu _popupMenuButton(BuildContext context){
    return PopupMenu(
      reverse: true,
      icon: Icon((mineChecked || otherChecked) ? RemixIcons.riFilterFill : RemixIcons.riFilterLine),
      menus: [
        PopupMenuModel(value: 1, title: "我发起", icon: mineChecked ? RemixIcons.riCheckLine : null),
        PopupMenuModel(value: 2, title: "我参与", icon: otherChecked ? RemixIcons.riCheckLine : null),
      ],
      onSelected: (value) {
        print(value);
        if (value == 1) {
          setState(() {
            mineChecked = !mineChecked;
            if (mineChecked && otherChecked) {
              otherChecked = false;
            }
          });
        }
        if (value == 2) {
          setState(() {
            otherChecked = !otherChecked;
            if (otherChecked && mineChecked) {
              mineChecked = false;
            }
          });
        }
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              title: const Text(
                '活动',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              elevation: 0,
              centerTitle: true,
              actions: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  width: 160,
                  margin: const EdgeInsets.only(bottom: 0, top: 0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 42,
                          top: 16,
                          child: Text(
                            mineChecked && !otherChecked ? '我发起' : !mineChecked && otherChecked ? '我参与' : '全部',
                            style: const TextStyle(color: Colors.black),
                          ),
                          // color: Colors.red,
                        ),
                        Positioned(
                          top: -6,
                          right: 0,
                          child: _popupMenuButton(context),
                        )
                      ],
                    ),
                  ),
                  // child: _popupMenuButton(context),
                )


              ],
            )),
      body: ListView.builder(
          itemCount: contactList.length,
          itemExtent: 56.0, //强制高度为50.0
          itemBuilder: (BuildContext context, int index) {
            ContactInfo model = contactList[index];
            return getWeChatItem(
              context,
              model,
              defHeaderBgColor: const Color(0xFFE5E5E5),
              onTap: (ContactInfo model) {
                RouteUtil.push(context, RoutePath.chatPage, params: model);
              }
            );
          }
      )
    );
  }

  Widget getWeChatItem(
      BuildContext context,
      ContactInfo model, {
        Color? defHeaderBgColor,
        Function(ContactInfo model)? onTap

      }) {
    DecorationImage? image;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(18.0),
          color: model.bgColor ?? defHeaderBgColor,
          image: image,
        ),
        child: model.iconData == null
            ? const Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        )
            : Icon(
          model.iconData,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(model.name),
      trailing: Text('未开始/进行中/已完成/待评分 4.6分'),
      onTap: () {
        LogUtil.e("onItemClick 11: $model");
        if (onTap != null) {
          onTap(model);
        }
      },
    );
  }
}
