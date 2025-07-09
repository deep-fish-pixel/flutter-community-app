import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/gardener_icons.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:tapped/tapped.dart';

class SelectCommunityPage extends StatefulWidget {
  const SelectCommunityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SelectCommunityState();
  }
}

class SelectCommunityState extends State<SelectCommunityPage>  with TickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  final FocusNode _communityInputNode = FocusNode();
  late TextEditingController _communityInputController;

  String communityInputValue = '';
  bool _communityInputFocus = false;
  String cityName = '上海市';
  List<String> _searchCityResults = [];

  @override
  void initState() {
    super.initState();

    _communityInputController = TextEditingController();

    _scrollController.addListener(() {
      setState(() {
        print('control======offset ${_scrollController.offset}');
      });
    });

    _communityInputNode.addListener((){
      setState(() => {
        _communityInputFocus = _communityInputNode.hasFocus
      });
    });

  }

  @override
  void dispose() {
    _communityInputController.dispose();
    super.dispose();
  }


  getCommunityText(){
    String name = '紫金东锅啊'.substring(0, 4);
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

  Widget buildHeader(int i) {
    String name = '我的常用社区';
    if (i == 2) {
      name = '附近社区';
    }
    return Container(
      alignment: Alignment.topLeft,
      child: Tapped(
        onTap: () {
          if (i == 1) {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn
            );
          }
          if (i == 2) {
            _scrollController.animateTo(2000,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn
            );
          }
        },
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 14, right: 14),
          color: Colors.white,
          height: 50,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 6),
                child: Icon(
                  (i == 1 ? RemixIcons.homeSmile2Line : RemixIcons.communityLine),
                  color: ThemeColors.mainBlack,
                  size: 20,
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                    color: ThemeColors.mainGray
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  // 构建固定高度的SliverList，count为列表项属相
  Widget buildSliverList([int count = 5]) {
    return SliverFixedExtentList(
      itemExtent: 60.0,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          if (index == count - 1) {
            return Container(
              color: Colors.white,
              margin: const EdgeInsets.only(left: 14, right: 14),
              child: Row(
                children: const [
                  Text(
                    '展开其他常用社区',
                    style: TextStyle(
                      color: ThemeColors.mainBlack,
                    ),
                  ),
                  Icon(
                    RemixIcons.arrowDownDLine,
                    color: ThemeColors.mainBlack,
                    size: 20,
                  ),
                ],
              ),
            );
          }
          return Container(
            margin: const EdgeInsets.only(left: 14, right: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: ThemeColors.mainGrayBackground,
                  width: 1
                )
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: (){
                      RouteUtil.pop(context, '紫金$index');
                    },
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            '紫金东郡$index',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: ThemeColors.mainBlack
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 4, right: 20),
                          child: Text(
                            'V${index+1}',
                            style: const TextStyle(
                                color: ThemeColors.mainBlack
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 14, right: 4),
                        child: const Icon(
                          RemixIcons.riUserLine,
                          size: 20,
                        ),
                      ),
                      Container(
                        child: Text(
                          'LV${index+1}',
                          style: const TextStyle(
                              color: ThemeColors.mainBlack
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        childCount: count,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('=========================SelectCommunityState');
    var args = RouteUtil.getParams(context);
    print('=========================SelectCommunityState $args');
    bool isRegister = args['operation'] == 'register';
    print('=========================SelectCommunityState $isRegister');
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                RouteUtil.pop(context);
                informationPageActiveNotifier.setActive(true);
              },
            ),
          ),
          title: const Text(
            '请选择社区',
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(110),
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var result = await RouteUtil.push(context, RoutePath.selectCommunityCityPage);
                          if (result != null && result.name != null) {
                            print("路由返回值: ${result.name}");
                            setState(() => cityName = result.name);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 14, right: 6),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 4),
                                child: const Icon(
                                  RemixIcons.mapPin2Line,
                                  size: 18,
                                ),
                              ),
                              Text(cityName),
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                child: const Icon(
                                  RemixIcons.arrowDownDLine,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            height: 36,
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color.fromARGB(255, 225, 226, 230), width: 0.33),
                                color: const Color.fromARGB(255, 239, 240, 244),
                                borderRadius: BorderRadius.circular(24)),
                            child: TextField(
                              autofocus: false,
                              focusNode: _communityInputNode,
                              controller: _communityInputController,
                              onChanged: (value) {
                                print('onChanged====$value');
                                _searchCityResults = [];
                                if (value.isNotEmpty) {
                                  _searchCityData();
                                }
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    RemixIcons.search,
                                    color: ThemeColors.mainGray33,
                                    size: 20,
                                  ),
                                  suffixIcon: Offstage(
                                    offstage: _communityInputController.text.isEmpty,
                                    child: InkWell(
                                      onTap: () {
                                        _communityInputController.clear();
                                        setState(() {
                                          FocusScope.of(context).requestFocus(_communityInputNode);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.cancel,
                                        color: ThemeColors.mainGray99,
                                      ),
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  hintText: '请输入社区名称',
                                  hintStyle: const TextStyle(
                                      color: ThemeColors.mainGray99,
                                      height: 1
                                  )
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 6),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: ThemeColors.mainGrayBackground,
                              width: 1
                          )
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  RouteUtil.pop(context, '上海科技绿洲');
                                },
                                child: Container(
                                  child: const Text(
                                    '上海科技绿洲',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: ThemeColors.mainBlack
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 4, right: 20),
                                  child: const Text(
                                    'V7',
                                    style: TextStyle(
                                        color: ThemeColors.mainBlack
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 14, right: 4),
                                child: const Icon(
                                  RemixIcons.riUserLine,
                                  size: 20,
                                ),
                              ),
                              Container(
                                child: const Text(
                                  'LV3',
                                  style: TextStyle(
                                      color: ThemeColors.mainBlack
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            RouteUtil.pop(context, '青年公寓');
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 14, right: 4),
                                child: const Icon(
                                  GardenerIcons.relocate,
                                  size: 20,
                                  color: ThemeColors.main,
                                ),
                              ),
                              const Text(
                                '重新定位',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: ThemeColors.main
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          alignment:Alignment.topLeft , //指定未定位或部分定位widget的对齐方式
          children: <Widget>[
            isRegister ? Container() : CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverHeaderDelegate.fixedHeight( //固定高度
                    height: 50,
                    child: buildHeader(1),
                  ),
                ),
                buildSliverList(6),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverHeaderDelegate.fixedHeight( //固定高度
                    height: 50,
                    child: buildHeader(2),
                  ),
                ),
                buildSliverList(20),
              ],
            ),
            getBackgroundContent(isRegister),
          ],
        )
    );
  }

  getBackgroundContent(bool isRegister){
    Color? color;

    if(isRegister) {
      color = Colors.white;
    } else if (_communityInputFocus) {
      color = _communityInputController.value.text.isEmpty ? Colors.black.withOpacity(0.35) : Colors.white;
    }

    return Positioned(
        child: GestureDetector(
          child: Container(
            color: color,
            child: getSearchResult(),
          ),
          onTap: (){
            _communityInputNode.unfocus();
          },
        )
    );
  }

  getSearchResult() {
    print('getSearchResult======${_communityInputController.value.text.isEmpty} ${_searchCityResults.length}');
    if (_communityInputController.value.text.isEmpty) {
      return null;
    }
    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemCount: _searchCityResults.length + 1,
        itemBuilder: (context, index) {
          if (_searchCityResults.length - 1 < 100 && index == _searchCityResults.length) {
            //获取数据
            _searchCityData();
            //加载时显示loading
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          }
          if (index == _searchCityResults.length) {
            return Container();
          }
          //显示单词列表项
          return ListTile(
            title: Row(
              children: [
                Text(
                  _searchCityResults[index],
                  style: const TextStyle(
                      fontWeight: FontWeight.w700
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'V7',
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                )
              ],
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 4),
              child: const Text(
                  '上海市黄浦区中山东二路8弄2号一百商务楼',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis
                ),
              ),
            ),
            onTap: (){
              RouteUtil.pop(context, _searchCityResults[index]);
            },
            /*trailing: Container(
              width: 80,
            )*/
          );
        },
        separatorBuilder: (context, index) => Divider(height: .0),
      )
    );
  }

  void _searchCityData() {
    Future.delayed(const Duration(seconds: 2)).then((e) {
      setState(() {
        //重新构建列表
        _searchCityResults.insertAll(
          _searchCityResults.length,
          //每次生成20个单词
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
        );
      });
    });
  }
}


typedef SliverHeaderBuilder = Widget Function(
    BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  // child 为 header
  SliverHeaderDelegate({
    required this.maxHeight,
    this.minHeight = 0,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  //最大和最小高度相同
  SliverHeaderDelegate.fixedHeight({
    required double height,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        maxHeight = height,
        minHeight = height;

  //需要自定义builder时使用
  SliverHeaderDelegate.builder({
    required this.maxHeight,
    this.minHeight = 0,
    required this.builder,
  });

  final double maxHeight;
  final double minHeight;
  final SliverHeaderBuilder builder;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    //测试代码：如果在调试模式，且子组件设置了key，则打印日志
    assert(() {
      if (child.key != null) {
        print('${child.key}: shrink: $shrinkOffset，overlaps:$overlapsContent');
      }
      return true;
    }());
    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverHeaderDelegate old) {
    return old.maxExtent != maxExtent || old.minExtent != minExtent;
  }
}