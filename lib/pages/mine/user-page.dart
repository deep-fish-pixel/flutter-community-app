import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/information/components/information_list.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/style/style.dart';
import 'package:gardener/pages/login_model_bottom_sheet.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/win_media.dart';
import 'package:tapped/tapped.dart';
import '../../constants/gardener_icons.dart';


const data = [1,2,3,4,5,6,7,8,9,10];

class UserPage extends StatefulWidget {
  final bool canPop;
  final Function? onPop;
  final Function? onSwitch;

  UserPage({
    Key? key,
    this.canPop: false,
    this.onPop,
    this.onSwitch,
  }) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  double _titleOpacity = 0;
  double extraPicHeight = 0;//初始化要加载到图片上的高度
  double prevDy = 0;//前一次手指所在处的y值'
  late AnimationController animationController;
  late Animation<double> anim;
  double flexibleSpaceHeight = 220.0;
  String statusBarMode = 'light';
  List<String> tabs = [
    '作品', '收藏', '点赞', '私密',
  ];

  @override
  void initState() {
    super.initState();
    print('userPage initState==================widget.canPop=' + widget.canPop.toString());
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      userPageTabActiveNotifier.setTabIndex(_tabController.index);
      userPageTabActiveNotifier.notifyListeners();
    });
    _scrollController.addListener(() {
      setState(() {
        print('control======offset ${_scrollController.offset} ${_scrollController.offset / 100} ${flexibleSpaceHeight}');
        _titleOpacity = max(0, min(1, (180 - flexibleSpaceHeight) / 100));

        print('control=====_titleOpacity ${_titleOpacity}');
        updateStatusBarBrightness();
      });
    });
    animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
  }

  void updateStatusBarBrightness() {
    if(flexibleSpaceHeight > 150) {
      statusBarMode = 'light';
    } else if (flexibleSpaceHeight <= 150) {
      statusBarMode = 'dark';
    }
  }

  renderIcons(){
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 20),
      child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Tapped(
                child: Column(
                  children: const [
                    Icon(Icons.account_box, size: 48,),
                    Text('任务', style: TextStyle(color: ThemeColors.mainBlack, height: 2),)
                  ],
                ),
                onTap: () => {
                  RouteUtil.push(context, RoutePath.taskPage)
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Tapped(
                child: Column(
                  children: const [
                    Icon(Icons.account_box, size: 48,),
                    Text('活动', style: TextStyle(color: ThemeColors.mainBlack, height: 2),)
                  ],
                ),
                onTap: () => {
                  RouteUtil.push(context, RoutePath.mineActivityPage)
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Tapped(
                child: Column(
                  children: const [
                    Icon(Icons.account_box, size: 48,),
                    Text('跟进', style: TextStyle(color: ThemeColors.mainBlack, height: 2),)
                  ],
                ),
                onTap: () => {

                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Tapped(
                child: Column(
                  children: const [
                    Icon(Icons.account_box, size: 48,),
                    Text('认证', style: TextStyle(color: ThemeColors.mainBlack, height: 2),)
                  ],
                ),
                onTap: () => {

                },
              ),
            ),
          ]
      ),
    );
  }

  updatePicHeight(changed){
    var divisor = (extraPicHeight + 100) * 50 / 100;
    if(prevDy == 0){//如果是手指第一次点下时，我们不希望图片大小就直接发生变化，所以进行一个判定。
      prevDy = changed/divisor;
    }
    extraPicHeight += changed/divisor - prevDy;//新的一个y值减去前一次的y值然后累加，作为加载到图片上的高度。
    if (extraPicHeight > 300) {
      extraPicHeight = 300;
    }
    setState(() {//更新数据
      print('updatePicHeight===============' + extraPicHeight.toString() + '=====$changed');
    });
  }

  runAnimate(){//设置动画让extraPicHeight的值从当前的值渐渐回到 0
    setState(() {
      anim = Tween(begin: extraPicHeight, end: 0.0).animate(animationController)
        ..addListener((){
          setState(() {
            extraPicHeight = anim.value;
          });
        });
      prevDy = 0;//同样归零
    });
  }

  @override
  Widget build(BuildContext context) {
    var isBack = RouteUtil.getParams(context) ?? '';
    bool showBack = widget.canPop || isBack == 'back';

    return Listener(
        onPointerDown: (result) {//手指的移动时
        },
        onPointerMove: (result) {//手指的移动时
          if (_scrollController.offset <= 0) {
            updatePicHeight(result.position.dy);//自定义方法，图片的放大由它完成。
          }
        },
        onPointerUp: (result) {//当手指抬起离开屏幕时
          runAnimate();//动画执行
          animationController.forward(from: 0);//重置动画
        },
        child: DefaultTabController(
          length: tabs.length,
          child: NestedScrollView(
              controller: _scrollController,
              // physics: const ClampingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: Opacity(
                        opacity: _titleOpacity ,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: 40,
                              // alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  "https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 30.0,
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  '小丸子1',
                                  style: TextStyle(
                                      color: ThemeColors.main,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: 60,
                              height: 26,
                              child: ButtonMain(
                                onPressed: (String text) {
                                  print('success!!!!!!');
                                  if (checkShowLoginModel(context)) {
                                    return;
                                  }
                                },
                                theme: ButtonMain.themeLine,
                                text: '关注',
                              ),
                            )
                          ],
                        )
                    ),
                    floating: true,
                    pinned: true, // 滑动到顶端时会固定住
                    forceElevated: true,
                    backgroundColor: Colors.white,
                    expandedHeight: 196 + extraPicHeight,
                    flexibleSpace: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          // print('constraints=' + constraints.toString());
                          flexibleSpaceHeight = constraints.biggest.height;
                          print('flexibleSpace top=====$flexibleSpaceHeight');
                          return FlexibleSpaceBar(
                              stretchModes: const [StretchMode.zoomBackground],
                              collapseMode: CollapseMode.pin,
                              background: SliverTopBar(
                                extraPicHeight: extraPicHeight,
                              )//自定义Widget
                          );
                        }
                    ),
                    leading: showBack ? GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: statusBarMode == 'dark' ? ThemeColors.mainBlack : Colors.white,
                        ),
                      ),
                      onTap: () {
                        // RouteUtil.pop(context);
                        // widget.onPop!();
                        if (showBack) {
                          if (widget.onPop == null) {
                            RouteUtil.pop(context);
                          } else {
                            widget.onPop!();
                          }
                        }
                      },
                    ) : Container(),
                    leadingWidth: showBack ? 40 : 0,
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(
                            RemixIcons.riSettingsLine,
                            color: statusBarMode == 'dark' ? ThemeColors.mainBlack : Colors.white,
                          ),
                          onPressed: () {
                            RouteUtil.push(context, RoutePath.userDetailPage);
                          }
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 10, top: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Opacity(
                                      opacity: max(0, 1 - _titleOpacity * 1.05),
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 74,
                                              width: 74,
                                              margin: EdgeInsets.only(left: 20, bottom: 12),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(44),
                                                color: ThemeColors.main,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Tapped(
                                                child: ClipOval(
                                                  child: Image.network(
                                                    "https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                onTap: (){
                                                  RouteUtil.push(context, RoutePath.userDetailPage);
                                                },
                                              )
                                          ),
                                          Container(
                                              height: 60,
                                              margin: EdgeInsets.only(left: 20),
                                              child: Tapped(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '小丸子',
                                                      style: StandardTextStyle.big,
                                                    ),
                                                    Text(
                                                      '家园号：xxwewe',
                                                      style: StandardTextStyle.small,
                                                    )
                                                  ],
                                                ),
                                                onTap: (){
                                                  RouteUtil.push(context, RoutePath.userDetailPage);
                                                },
                                              )
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              margin: const EdgeInsets.only(right: 20),
                                              width: 60,
                                              height: 26,
                                              child: ButtonMain(
                                                onPressed: (String text) {
                                                  print('success!!!!!!');
                                                  if (checkShowLoginModel(context)) {
                                                    return;
                                                  }
                                                },
                                                theme: ButtonMain.themeLine,
                                                text: '关注',
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width - 40,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: 3,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          TextGroup('1356', '关注', color: Colors.black87),
                                          TextGroup('145万', '粉丝', color: Colors.black87),
                                          TextGroup('1423万', '获赞', color: Colors.black87),
                                        ],
                                      ),
                                    ),
                                    Container(height: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 3,
                                      ),
                                      child: Text(
                                        '朴实无华，且枯燥朴实无华，且枯燥朴实无华，且枯燥朴实无华，且枯燥朴实无华，且枯燥朴实无华，且枯燥',
                                        style: StandardTextStyle.smallWithOpacity.apply(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Container(height: 10),
                                    Row(
                                      children: <Widget>[
                                        _UserTag(tag: '幽默'),
                                        _UserTag(tag: '机智'),
                                        _UserTag(tag: '枯燥'),
                                        _UserTag(tag: '狮子座'),
                                      ],
                                    ),
                                    renderIcons()
                                  ],
                                ),
                              ),
                            ],
                          ),],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverHeaderDelegate.fixedHeight( //固定高度
                      height: 60,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 10),
                        child: TabBar(
                          controller: _tabController,
                          tabs: tabs.map((f) => Tab(text: f)).toList(),
                          indicatorColor: Colors.red,
                          unselectedLabelColor: Colors.black,
                          labelColor: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                color: Colors.white,
                child: TabBarView( //构建
                  controller: _tabController,
                  children: tabs.map((e) {
                    return Builder(
                      builder: (BuildContext context) {
                        final scr = PrimaryScrollController.of(context);
                        return Container(
                          alignment: Alignment.topLeft,
                          child: InformationList(
                            tabIndex: tabs.indexOf(e),
                            tabActiveNotifier: userPageTabActiveNotifier,
                            informationPageActiveNotifier: userPageActiveNotifier,
                            scrollController: scr,
                            userPage: true,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              )
          ),
        )
    );
  }

  // 构建固定高度的SliverList，count为列表项属相
  Widget buildSliverList([int count = 5]) {
    return SliverFixedExtentList(
      itemExtent: 50.0,
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          //创建列表项
          return Container(
            alignment: Alignment.center,
            child: Text('$index'),
          );
        },
        childCount: count,
      ),
    );
  }

  // 构建 header
  Widget buildHeader(int i) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text("Headerrr $i"),
    );
  }

  void dispose(){
    informationPageActiveNotifier.setActive(true);
  }
}


class _UserTag extends StatelessWidget {
  final String? tag;
  const _UserTag({
    Key? key,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          child: Text(tag ?? '标签', style: TextStyle(color: Colors.white),),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xff5E6573)),                //背景颜色
            foregroundColor: MaterialStateProperty.all(Color(0xff5E6573)),                //字体颜色
            overlayColor: MaterialStateProperty.all(Color(0xffffffff)),                   // 高亮色
            shadowColor: MaterialStateProperty.all( Color(0xffffffff)),                  //阴影颜色
            elevation: MaterialStateProperty.all(0),                                     //阴影值
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 10)),              //字体
            side: MaterialStateProperty.all(const BorderSide(
                width: 1,
                color: Color(0x00C7C7C7)
            )),//边框
            shape: MaterialStateProperty.all(
                const StadiumBorder(
                    side: BorderSide(
                      //设置 界面效果
                      style: BorderStyle.solid,
                      color: Color(0xffFF7F24),
                    )
                )
            ),//圆角弧度
          ),
          onPressed: () {  },
        )
    );
  }
}

class _UserVideoTable extends StatefulWidget {
  const _UserVideoTable({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserVideoTableState();
  }
}

class _UserVideoTableState extends State<_UserVideoTable>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((index) {
        return Container(
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              _SmallVideo(index: index),
              _SmallVideo(index: index + 1),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SmallVideo extends StatelessWidget {
  final int index;

  const _SmallVideo({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child:Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 4, right: 4, bottom: 2),
            height: 250,
            child: Image(
                alignment: Alignment.center,
                fit: BoxFit.fill,
                height: 150,
                image: NetworkImage(
                    [
                      'https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp',
                      'https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp',
                      'https://img.xiumi.us/xmi/ua/3wa69/i/65e1e8689e829901b04b1bfa5ba96a40-sz_139219.jpg?x-oss-process=style/xmwebp',
                      'https://img.xiumi.us/xmi/ua/3wa69/i/4cf7841f92d13a67c0f25738ba1d3266-sz_125868.jpg?x-oss-process=style/xmwebp',
                      'https://img.xiumi.us/xmi/ua/3wa69/i/3553a9363cf990862c6f236559fc98ca-sz_195633.jpg?x-oss-process=style/xmwebp',
                      'https://img.xiumi.us/xmi/ua/3wa69/i/73414e98d6debe9f42526875cb8658cf-sz_224834.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_1050,w_1050,x_0,y_175/format,webp',
                      'https://img.xiumi.us/xmi/ua/3wa69/i/f80f3fc92d07972d039c74b8475ea562-sz_193955.jpg?x-oss-process=style/xmwebp',
                      'https://img.xiumi.us/xmi/ua/3wa69/i/69eb48fe55532c85934cdf24807fc3f8-sz_181952.jpg?x-oss-process=style/xmwebp',
                      'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F0814%2F17c8e8c3c106b879aa9f4e9189601c3b.jpg&refer=http%3A%2F%2Ffile02.16sucai.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663541917&t=a9a98cdae0ef8d8c280fe105ac01f852'
                    ][index % 9]
                )
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 8),
            child: Text(
              '废弃公司办公楼',
              style: TextStyle(
                  color: ThemeColors.mainBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              height: 50,
              margin: EdgeInsets.only(top: 6, bottom: 6),
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.bottomLeft,
              child: OverflowBox(
                alignment: Alignment.bottomLeft,
                minHeight: 20,
                maxHeight: 300,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Container(
                      height: 37,
                      width: 37,
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.orange,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          "https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          height: 36,
                          margin: EdgeInsets.only(left: 6),
                          child: Text(
                            '小丸子11111111111',
                            style: TextStyle(
                              color: ThemeColors.black02,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(right: 6),
                      height: 40,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(GardenerIcons.like, size: 22),
                          Flexible(child: Text(
                            "2222",
                            style: TextStyle(fontSize: 14),
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class TextGroup extends StatelessWidget {
  final String title, tag;
  final Color? color;

  const TextGroup(
      this.title,
      this.tag, {
        Key? key,
        this.color,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: StandardTextStyle.big.apply(color: color),
          ),
          Container(width: 4),
          Text(
            tag,
            style: StandardTextStyle.smallWithOpacity.apply(
              color: color?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar widget;
  final Color color;

  const SliverTabBarDelegate(this.widget, {required this.color})
      : assert(widget != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
      child: widget,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => widget.preferredSize.height;

  @override
  double get minExtent => widget.preferredSize.height;
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


class SliverTopBar extends StatelessWidget{
  const SliverTopBar({Key? key, required this.extraPicHeight}) : super(key: key);
  final double extraPicHeight;//传入的加载到图片上的高度

  @override
  Widget build(BuildContext context) {
    print('SliverTopBar====$extraPicHeight');
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(//缩放的图片
                width: MediaQuery.of(context).size.width,
                child: Image.network("https://th.bing.com/th/id/OIP.lRLLKdA28DGKTuiEAsl_EAHaEK?pid=ImgDet&rs=1",
                    height: 220 + extraPicHeight,
                    fit: BoxFit.cover),
              ),
            ],
          ),
          Positioned(
            left: 0,
            top: 201 + extraPicHeight,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              width: winWidth(context),
              height: 20,
              child: Container(),
            ),

          )
        ],

      ),
    );
  }

}


TabActiveNotifier userPageTabActiveNotifier = TabActiveNotifier();

InformationPageActiveNotifier userPageActiveNotifier = InformationPageActiveNotifier();


