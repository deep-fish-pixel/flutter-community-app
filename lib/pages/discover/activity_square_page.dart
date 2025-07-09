import 'dart:convert';
import 'dart:ffi';

import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/pop_up_menu.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/group/group_category_model.dart';
import 'package:gardener/pages/message/contants_page/common/models.dart';
import 'package:gardener/pages/mine/activity/mine_activity_page.dart';
import 'package:gardener/util/name_value.dart';

class ActivityFilter {
  static NameValue<String> notStarted = NameValue<String>(
      name: '未开始',
      value: '1'
  );
  static NameValue<String> started = NameValue<String>(
      name: '进行中',
      value: '2'
  );
  static NameValue<String> ended = NameValue<String>(
      name: '已结束',
      value: '3'
  );
  static NameValue<String> unexpectedTermination = NameValue<String>(
      name: '意外终止',
      value: '4'
  );
}

List<NameValue<String>> activityFilters = [
  ActivityFilter.notStarted,
  ActivityFilter.started,
  ActivityFilter.ended,
  ActivityFilter.unexpectedTermination,
];


class ActivitySquarePage extends StatefulWidget {
  @override
  _ActivitySquarePageState createState() => _ActivitySquarePageState();
}

class _ActivitySquarePageState extends State<ActivitySquarePage> with TickerProviderStateMixin {
  late TabController tabController;
  late TabController subTabControllerList;
  late GroupCategoryModel groupCategory;
  List<ContactInfo> contactList = [];
  String filterValue = '';


  @override
  void initState() {
    super.initState();
    loadData();

    groupCategory = GroupCategoryModel(
          name: '兴趣',
          children: [
            GroupCategoryModel(name: '推荐'),
            GroupCategoryModel(name: '垂钓'),
            GroupCategoryModel(name: '养花'),
            GroupCategoryModel(name: '养宠'),
            GroupCategoryModel(name: '自驾'),
            GroupCategoryModel(name: '交友'),
            GroupCategoryModel(name: '旅行'),
            GroupCategoryModel(name: '野营'),
            GroupCategoryModel(name: '摄影'),
            GroupCategoryModel(name: '音乐'),
            GroupCategoryModel(name: '游戏'),
            GroupCategoryModel(name: '电子产品'),
            GroupCategoryModel(name: '影视动漫'),
            GroupCategoryModel(name: '其他'),
            GroupCategoryModel(name: '推荐'),
            GroupCategoryModel(name: '情感'),
            GroupCategoryModel(name: '老乡'),
            GroupCategoryModel(name: '美食'),
            GroupCategoryModel(name: '健康'),
            GroupCategoryModel(name: '宠物'),
            GroupCategoryModel(name: '二手'),
            GroupCategoryModel(name: '运动'),
            GroupCategoryModel(name: '汽车'),
            GroupCategoryModel(name: '育儿'),
            GroupCategoryModel(name: '成人教育'),
            GroupCategoryModel(name: '子女教育'),
            GroupCategoryModel(name: '投资理财'),
          ]
      );

    // tabController = TabController(length: groupCategory.length, vsync: this);
    subTabControllerList = TabController(length: groupCategory.children.length, vsync: this);
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
        icon: Icon(filterValue != '' ? RemixIcons.riFilterFill : RemixIcons.riFilterLine),
        menus: [
          PopupMenuModel(value: ActivityFilter.notStarted.value, title: ActivityFilter.notStarted.name, icon: filterValue == ActivityFilter.notStarted.value ? RemixIcons.riCheckLine : null),
          PopupMenuModel(value: ActivityFilter.started.value, title: ActivityFilter.started.name, icon: filterValue == ActivityFilter.started.value ? RemixIcons.riCheckLine : null),
          PopupMenuModel(value: ActivityFilter.ended.value, title: ActivityFilter.ended.name, icon: filterValue == ActivityFilter.ended.value ? RemixIcons.riCheckLine : null),
          PopupMenuModel(value: ActivityFilter.unexpectedTermination.value, title:ActivityFilter.unexpectedTermination.name, icon: filterValue == ActivityFilter.unexpectedTermination.value ? RemixIcons.riCheckLine : null),
        ],
        onSelected: (value) {
          setState(() {
            if (filterValue == value) {
              filterValue = '';
            } else {
              filterValue = value;
            }
          });
          print(filterValue);
        }
    );
  }



  @override
  void dispose() {
    subTabControllerList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        shape: Border(
            bottom: BorderSide(width: 0.5, color: Colors.grey.shade300)
        ),
        leading: GestureDetector(
          child: Container(
            width: 120,
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: const [
                Icon(
                  Icons.arrow_back_ios_new,
                ),
              ],
            ),
          ),
          onTap: () {
            print('onTap');
            Navigator.pop(context);
          },
        ),
        title: const SizedBox(
          height: 32.0,
          child: Text('活动广场'),
        ),
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
                      filterValue != '' ? activityFilters[int.parse(filterValue) - 1].name : '',
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
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Column(
          children: <Widget>[
            Container(
              height: 44,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  indicatorColor: const Color(0xffFF3700),
                ),
                child: TabBar(
                  isScrollable: true,
                  labelColor: ThemeColors.mainBlack,
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  // indicator: BoxDecoration(),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ThemeColors.mainGrayOverlay,
                  ),
                  unselectedLabelColor: ThemeColors.mainGray,
                  tabs: groupCategory.children.map((subGroupCategory) => Tab(text: subGroupCategory.name)).toList(),
                  controller: subTabControllerList,
                ),
              ),
            ),
            Expanded(
              child: ExtendedTabBarView(
                shouldIgnorePointerWhenScrolling: false,
                controller: subTabControllerList,
                /// if link is true and current tabbarview over scroll,
                /// it will check and scroll ancestor or child tabbarView.
                link: true,
                /// cache page count
                /// default is 0.
                /// if cacheExtent is 1, it has two pages in cache
                cacheExtent: 1,
                children: groupCategory.children.map((subGroupCategory) {
                  return ListView.builder(
                      itemCount: contactList.length,
                      itemExtent: 432.0,
                      itemBuilder: (BuildContext context, int index) {
                        ContactInfo model = contactList[index];
                        return ActivityCard(
                            model: model
                        );
                      }
                  );
                }).toList(),
                // children: groupCategory.children.map((subGroupCategory) => GroupListWidget('Tab000')).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}