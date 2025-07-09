import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/pop_up_menu.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/char_info/chat_members.dart';
import 'package:gardener/pages/message/contants_page/activity/activity_info.dart';
import 'package:gardener/pages/message/contants_page/common/index.dart';
import 'package:gardener/pages/message/contants_page/common/models.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/win_media.dart';


class MineActivityPage extends StatefulWidget {
  const MineActivityPage({Key? key}) : super(key: key);

  @override
  _MineActivityPageState createState() => _MineActivityPageState();
}

class _MineActivityPageState extends State<MineActivityPage> {
  List<ContactInfo> contactList = [];
  bool mineChecked = false;
  bool otherChecked = false;

  @override
  void initState() {
    super.initState();
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
      body: Container(
        color: Colors.grey.shade300,
        child: ListView.builder(
            itemCount: contactList.length,
            itemExtent: 432.0,
            itemBuilder: (BuildContext context, int index) {
              ContactInfo model = contactList[index];
              return ActivityCard(
                model: model
              );
            }
        ),
      )
    );
  }


}



class ActivityCard extends StatelessWidget {
  final ContactInfo model;

  const ActivityCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 14),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              RouteUtil.push(context, RoutePath.activityInfoPage);
            },
            child: Container(
                height: 140,
                width: winWidth(context) - 10,
                child: Image.network('https://img.zcool.cn/community/01c6615d3ae047a8012187f447cfef.jpg@1280w_1l_2o_100sh.jpg',
                  fit: BoxFit.cover,
                )
            ),
          ),
          GestureDetector(
            onTap: () {
              RouteUtil.push(context, RoutePath.activityInfoPage);
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: ListTile(
                enabled: false,
                leading: Container(
                  height: 40,
                  width: 40,
                  child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Image(
                        image: CachedNetworkImageProvider('https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp'),
                      )
                  ),
                ),
                title: const Text(
                  '一起去跑步一起去跑',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: ThemeColors.mainBlack
                  ),
                ),
                trailing: Column(
                  children: const [
                    Text(
                      '待开始/进行中',
                      style: TextStyle(
                          fontSize: 10,
                          color: ThemeColors.mainGreen
                      ),
                    ),
                    Text(
                      '已终止',
                      style: TextStyle(
                          fontSize: 10,
                          color: ThemeColors.mainGray
                      ),
                    ),
                    Text(
                      '已结束 4.8分/待评价',
                      style: TextStyle(
                          fontSize: 10,
                          color: ThemeColors.main
                      ),
                    )
                  ],
                ),
                onTap: () {
                  LogUtil.e("onItemClick");
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              RouteUtil.push(context, RoutePath.activityInfoPage);
            },
            child: SizedBox(
              width: winWidth(context) - 20,
              child: const ActivityInfo(
                  card: true
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              RouteUtil.push(context, RoutePath.activityInfoPage);
            },
            child: ChatMembers(
                activity: true,
                card: true,
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
          ),
        ],
      ),
    );
  }

}



