import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/components/label_row.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/pages/message/char_info/chat_members.dart';
import 'package:gardener/pages/message/contants_page/common/index.dart';
import 'package:gardener/util/toast.dart';
import 'package:gardener/util/win_media.dart';

class ActivityInfoPage extends StatefulWidget {
  const ActivityInfoPage({
    Key? key,
  }) : super(key: key);

  @override
  _ActivityInfoPageState createState() => _ActivityInfoPageState();
}

class _ActivityInfoPageState extends State<ActivityInfoPage>{
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        print('control======offset ${_scrollController.offset} ${_scrollController.offset / 100}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: winHeight(context) - 60,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverCustomHeaderDelegate(
                      title: '一起去跑步1',
                      collapsedHeight: 40,
                      expandedHeight: 220,
                      scrollOffset: _scrollController.hasClients ? _scrollController.offset : 0,
                      paddingTop: MediaQuery.of(context).padding.top,
                      coverImgUrl: 'https://img.zcool.cn/community/01c6615d3ae047a8012187f447cfef.jpg@1280w_1l_2o_100sh.jpg'
                  ),
                ),
                SliverToBoxAdapter(
                  child: ActivityContent(
                    scrollOffset: _scrollController.hasClients ? _scrollController.offset : 0
                  ),
                ),
                /*SliverToBoxAdapter(
            child: ActivityContent(),
          )*/
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonMain(
                margin: const EdgeInsets.only(top: 10),
                width: winWidth(context) - 40,
                height: 40,
                fontSize: 14,
                onPressed: (String text) {
                  print('我要报名!!!!!!');
                  Toast.show('你是未婚人士，不能参加该活动', context, type: ToastType.error);
                },
                text: '我要报名',
              )
            ],
          )
        ],
      )
    );
  }

  void dispose(){
    informationPageActiveNotifier.setActive(true);
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final double scrollOffset;
  final String coverImgUrl;
  final String title;

  String statusBarMode = 'dark';

  SliverCustomHeaderDelegate({
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.paddingTop,
    required this.scrollOffset,
    required this.coverImgUrl,
    required this.title,
  });

  @override
  double get minExtent => collapsedHeight + paddingTop;

  @override
  double get maxExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  void updateStatusBarBrightness(shrinkOffset) {
    if(shrinkOffset > 50 && statusBarMode == 'dark') {
      statusBarMode = 'light';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if(shrinkOffset <= 50 && statusBarMode == 'light') {
      statusBarMode = 'dark';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if(shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  double makeStickyHeaderOpacity(shrinkOffset) {
    var alpha = shrinkOffset / (maxExtent - minExtent);
    print('makeStickyHeaderOpacity==== $shrinkOffset $maxExtent $minExtent ${(shrinkOffset / (maxExtent - minExtent) * 255) } $alpha ');
    return min(1, max(0, alpha));
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // updateStatusBarBrightness(shrinkOffset);
    return Container(
      height: maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(child: Image.network(coverImgUrl, fit: BoxFit.cover)),
          Positioned(
            left: 0,
            top: 204 - scrollOffset,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              width: winWidth(context),
              height: 20,
              child: Container(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: makeStickyHeaderBgColor(shrinkOffset - 20),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: makeStickyHeaderTextColor(shrinkOffset - 50, true),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Container(
                            height: 32,
                            width: 32,
                            child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Opacity(
                                  opacity: makeStickyHeaderOpacity(shrinkOffset - 50),
                                  child: const Image(
                                    image: CachedNetworkImageProvider('https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp'),
                                  ),
                               )
                            ),
                          ),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: makeStickyHeaderTextColor(shrinkOffset, false),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: makeStickyHeaderTextColor(shrinkOffset, true),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityContent extends StatelessWidget {
  double scrollOffset = 0;

  ActivityContent({
    Key? key,
    required this.scrollOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ActivityContent build=====$scrollOffset ${min(1, max(0, (200 - scrollOffset) / 100))}');
    const images = <String>[
      'https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp',
      'https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp',
      'https://img.xiumi.us/xmi/ua/3wa69/i/65e1e8689e829901b04b1bfa5ba96a40-sz_139219.jpg?x-oss-process=style/xmwebp',
      'https://img.xiumi.us/xmi/ua/3wa69/i/4cf7841f92d13a67c0f25738ba1d3266-sz_125868.jpg?x-oss-process=style/xmwebp',
    ];
    return Stack(
      children: [
        Positioned(
          child: Container(
              decoration: const BoxDecoration(
                // color: ColorPlate.back1,
                // color: Colors.green,
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Opacity(
                    opacity: min(1, max(0, (200 - scrollOffset) / 100)),
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
                        '一起去跑步',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: ThemeColors.mainBlack
                        ),
                      ),
                      trailing: Column(
                        children: const [
                          Text(
                            '报名截止倒计时',
                            style: TextStyle(
                                fontSize: 14,
                                color: ThemeColors.mainGray,
                              height: 2
                            ),
                          ),
                          Text(
                            '1天23小时30分23秒',
                            style: TextStyle(
                                fontSize: 12,
                                color: ThemeColors.main
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        LogUtil.e("onItemClick");
                      },
                    ),
                  ),
                  Divider(height: 32),
                  LabelRow(
                    label: '活动地点',
                    rightW: const Text(
                      '43栋活动室',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: ThemeColors.mainGray,
                      ),),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    onPressed: () => { /*routePush(ChatBackgroundPage()) */},
                  ),
                  LabelRow(
                    label: '活动费用',
                    rightW: const Text(
                        '50￥/人 免费',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: ThemeColors.mainGray,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    onPressed: () => { /*routePush(ChatBackgroundPage()) */},
                  ),
                  LabelRow(
                    label: '开始时间',
                    rightW: const Text(
                      '2022-12-29 9:00',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: ThemeColors.mainGray,
                      ),),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    onPressed: () => { /*routePush(ChatBackgroundPage()) */},
                  ),
                  LabelRow(
                    label: '活动时长',
                    rightW: const Text(
                        '2小时',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: ThemeColors.mainGray,
                      ),),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    onPressed: () => { /*routePush(ChatBackgroundPage()) */},
                  ),
                  LabelRow(
                    label: '宝宝年龄',
                    rightW: const Text(
                        '3-5岁',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: ThemeColors.mainGray,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    onPressed: () => { /*routePush(ChatBackgroundPage()) */},
                  ),
                  ChatMembers(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        '天地灵气孕育出一颗能量巨大的混元珠，元始天尊将混元珠提炼成灵珠和魔丸，灵珠投胎为人，助周伐纣时可堪大用；而魔丸则会诞出魔王，为祸人间。元始天尊启动了天劫咒语，3年后天雷将会降临，摧毁魔丸。太乙受命将灵珠托生于陈塘关李靖家的儿子哪吒身上。然而阴差阳错，灵珠和魔丸竟然被掉包。本应是灵珠英雄的哪吒却成了混世大魔王。调皮捣蛋顽劣不堪的哪吒却徒有一颗做英雄的心。然而面对众人对魔丸的误解和即将来临的天雷的降临，哪吒是否命中注定会立地成魔？他将何去何从？',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                  ...images.map((image) => Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Image.network(image, fit: BoxFit.cover),
                  ))
                ],
              ),
            )
        )
      ],
    );
  }
}



