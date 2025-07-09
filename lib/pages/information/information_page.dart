import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import './components/information_list.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return InformationState();
  }
}

class InformationState extends State<InformationPage>
    with SingleTickerProviderStateMixin {
  // 存放各个可选项的数组
  List<String> tabs = [
    '关注', '推荐', '周边'
  ];
  // 创建切换控制器
  late TabController _tabController;
  String communityName = '';

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this, initialIndex: 1);
    communityName = SharedUtil.getString(SPKeys.community) ?? '科技绿洲三期';

    _tabController.addListener(() {
      tabActiveNotifier.setTabIndex(_tabController.index);
      tabActiveNotifier.notifyListeners();
    });
    tabActiveNotifier.setTabIndex(1);
  }

  static Widget getCommunityText(String communityName){
    String name = communityName;
    if (communityName.length > 4) {
      name = communityName.replaceFirst(RegExp(r'上海'), '').substring(0, 4);
    }

    double fontSize = 12.4;
    if (name.length == 1) {
      fontSize = 20;
    } else if (name.length == 2) {
      fontSize = 15;
    }

    return Text(
      name,
      maxLines: 2,

      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        height: 1.2
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('=========================InformationState');

    return Scaffold(
      appBar: AppBar(
        leading: null,
        leadingWidth: 0,
        title: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: UnconstrainedBox(
                alignment:Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    informationPageActiveNotifier.setActive(false);
                    var result = await RouteUtil.push(
                      context,
                      RoutePath.selectCommunityPage,
                      animate: RouteAnimate.swipe,
                      swipeEdge: false
                    );
                    informationPageActiveNotifier.setActive(true);
                    if (result != null) {
                      setState((){
                        communityName = result;
                      });
                    }
                  },
                  child: Container(
                    height: 36,
                    width: 36,
                    child: Stack(
                      alignment:Alignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            color: ThemeColors.main,
                          ),
                          alignment: Alignment.center,
                          child: getCommunityText(communityName),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: SizedBox(
                  height: 30.0,
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      indicatorColor: const Color(0xffFF3700),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: ThemeColors.mainBlack,
                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      tabs: tabs.map((e) => Tab(text: e)).toList(),
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: ThemeColors.mainGray,
                    )
                  )
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerRight,
                height: 30.0,
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    RouteUtil.push(context, RoutePath.informationSearchPage, animate: RouteAnimate.none);
                    informationPageActiveNotifier.setActive(false);
                  },
                ),
              ),
            )
          ],
        ),
        automaticallyImplyLeading: false
      ),
      body: TabBarView( //构建
        controller: _tabController,
        children: tabs.map((e) {
          int x = tabs.indexOf(e);
          print(x);
          return Container(
            alignment: Alignment.topLeft,
            child: InformationList(
              tabIndex: tabs.indexOf(e),
              tabActiveNotifier: tabActiveNotifier,
              informationPageActiveNotifier: informationPageActiveNotifier
            ),
          );
        }).toList(),
      ),
    );
  }
}


class TabActiveNotifier extends ChangeNotifier{
  int _tabIndex = -1;

  setTabIndex(int tabIndex){
    _tabIndex = tabIndex;
  }

  getTabIndex(){
    return _tabIndex;
  }
}

TabActiveNotifier tabActiveNotifier = TabActiveNotifier();

class InformationPageActiveNotifier extends ChangeNotifier{
  bool _active = true;

  setActive(bool active){
    _active = active;
    notifyListeners();
  }

  getActive(){
    return _active;
  }
}

InformationPageActiveNotifier informationPageActiveNotifier = InformationPageActiveNotifier();