import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/group/group_category_model.dart';
import 'package:gardener/pages/discover/groups/group_list.dart';


class GroupSquarePage extends StatefulWidget {
  @override
  _GroupSquarePageState createState() => _GroupSquarePageState();
}

class _GroupSquarePageState extends State<GroupSquarePage> with TickerProviderStateMixin {
  late TabController tabController;
  late List<TabController> subTabControllerList = [];
  late List<GroupCategoryModel> groupCategoryList = [];

  @override
  void initState() {
    super.initState();

    groupCategoryList = [
      GroupCategoryModel(
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
          ]
      ),
      GroupCategoryModel(
          name: '生活',
          children: [
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
            GroupCategoryModel(name: '其他'),
          ]
      )
    ];

    tabController = TabController(length: groupCategoryList.length, vsync: this);
    subTabControllerList = groupCategoryList.map((groupCategory) => TabController(length: groupCategory.children.length, vsync: this)).toList();
  }

  @override
  void dispose() {
    tabController.dispose();
    subTabControllerList.forEach((subTabController) {
      subTabController.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int subIndex = -1;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        shape: Border(
            bottom: BorderSide(width: 0.5, color: Colors.grey.shade300)
        ),
        leading: GestureDetector(
          child: Container(
            width: 120,
            margin: EdgeInsets.only(left: 0),
            child: Row(
              children: const [
                Icon(
                  Icons.arrow_back_ios_new,
                ),
                Text(
                  '群广场',
                  style: TextStyle(
                    color: ThemeColors.mainBlack,
                    fontSize: 18
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            print('onTap');
            Navigator.pop(context);
          },
        ),
        title: Container(
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                ),
              ),
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: 34.0,
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      indicatorColor: const Color(0xffFF3700),
                    ),
                    child: TabBar(
                      labelColor: ThemeColors.mainBlack,
                      labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: ThemeColors.mainGray,
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: groupCategoryList.map((groupCategory) => Tab(text: groupCategory.name)).toList(),
                      controller: tabController,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                ),
              )
            ],
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: ExtendedTabBarView(
        shouldIgnorePointerWhenScrolling: false,
        controller: tabController,
        children: groupCategoryList.map((groupCategory){
          subIndex++;

          return Column(
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
                      color: ThemeColors.mainGrayBackground,
                    ),
                    unselectedLabelColor: ThemeColors.mainGray,
                    tabs: groupCategory.children.map((subGroupCategory) => Tab(text: subGroupCategory.name)).toList(),
                    controller: subTabControllerList[subIndex],
                  ),
                ),
              ),
              Expanded(
                child: ExtendedTabBarView(
                  shouldIgnorePointerWhenScrolling: false,
                  children: groupCategory.children.map((subGroupCategory) => GroupListWidget('Tab000')).toList(),
                  controller: subTabControllerList[subIndex],

                  /// if link is true and current tabbarview over scroll,
                  /// it will check and scroll ancestor or child tabbarView.
                  link: true,

                  /// cache page count
                  /// default is 0.
                  /// if cacheExtent is 1, it has two pages in cache
                  cacheExtent: 1,
                ),
              )
            ],
          );
        }).toList()
      ),
    );
  }
}