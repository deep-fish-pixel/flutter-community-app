import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:gardener/components/single_auto_play_video.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/pages/login_model_bottom_sheet.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../components/sudoku_images.dart';
import '../../../constants/themes.dart';
import '../../../models/blog/video_model.dart';

class InformationList extends StatefulWidget {
  final int tabIndex;
  final bool userPage;
  final TabActiveNotifier? tabActiveNotifier;
  final InformationPageActiveNotifier? informationPageActiveNotifier;
  final ScrollController? scrollController;

  const InformationList({
    Key? key,
    this.tabIndex = -1,
    this.userPage = false,
    this.tabActiveNotifier,
    this.informationPageActiveNotifier,
    this.scrollController
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InformationListViewState();
  }
}

class _InformationListViewState extends State<InformationList> with AutomaticKeepAliveClientMixin {
  static const loadingTag = "##loading##"; //表尾标记
  final _words = <String>[loadingTag];
  var _urls = <String>[];
  final List<VideoModel> _videoList = <VideoModel>[];
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _retrieveData();
    setState(() {
      //重新构建列表
      _urls = [];
      _urls.addAll(
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
        ],
      );
      _videoList.add(VideoModel(
        url: 'https://video.momocdn.com/feedvideo/D5/78/D578F8D2-1A5F-2B45-131E-0C1881A32FDF20220820.mp4',
        preview: 'https://xp.qpic.cn/oscar_pic/0/szg_1877_50001_0b53leaacaaaziacq75jxrrfcwodafmqaaka_400_1/480',
        horizontal: true,
      ));
      _videoList.add(VideoModel(
        url: 'https://video.momocdn.com/feedvideo/17/49/1749BE36-6497-B81C-89EE-3E5BA3544C3D20210505.mp4',
        preview: 'https://xp.qpic.cn/oscar_pic/0/gzc_8338_1047_0bc3y4bjgaacyaafrrf3ljrblryespdqfe2a_400_1/480',
        horizontal: false,
      ));
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _words.length,
      controller: widget.scrollController != null ? null : _scrollController,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        //如果到了表尾
        if (_words[index] == loadingTag) {
          //不足100条，继续获取数据
          if (_words.length - 1 < 200) {
            //获取数据
            _retrieveData();
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
          } else {
            //已经加载了100条数据，不再获取数据。
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                "没有更多了",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
        }
        //显示单词列表项
        return ListTile(title: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      informationPageActiveNotifier.setActive(false);
                      RouteUtil.push(
                        context,
                        RoutePath.userPage,
                        params: 'back',
                        animate: RouteAnimate.swipe,
                        swipeEdge: false
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      alignment: Alignment.centerLeft,
                      child: Container(
                          width: 54,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(54),
                          ),
                          child: Image(
                            image: CachedNetworkImageProvider(_urls[index % 9]),
                          )
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () async {
                        informationPageActiveNotifier.setActive(false);
                        RouteUtil.push(
                            context,
                            RoutePath.userPage,
                            params: 'back',
                            animate: RouteAnimate.swipe,
                            swipeEdge: false
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 30.0,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _words[index] + index.toString(),
                              style: const TextStyle(
                                  color: ThemeColors.main,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              '等级3',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ],
                      )
                    )
                  ),
                  ButtonMain(
                    onPressed: (String text) async {
                      informationPageActiveNotifier.setActive(false);
                      RouteUtil.push(
                          context,
                          RoutePath.activityInfoPage,
                          params: 'back',
                          animate: RouteAnimate.swipe,
                          swipeEdge: false
                      );
                    },
                    text: '加入活动',
                  ),
                ],
              ),
              Container(
                child: GestureDetector(
                  onTap: (){
                    gotoMedia(index);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 50.0,
                        alignment: Alignment.topLeft,
                        child: const Text(
                          '有没有宅男1，又皮痒了，来伤害我一下。\n看我不打死你......',
                          style: TextStyle(
                            color: Color(0xFF5D5E5E), //Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: renderMedia(index),
                      ),
                      Container(
                        height: 25.0,
                        alignment: Alignment.topLeft,
                        child: const Text('活动 | 娱乐 | 促销 · 1小时前'),
                      ),
                    ],
                  ),
                ),
              ),

              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          child: IconButton(
                            icon: Icon(RemixIcons.thumbUpLine),
                            onPressed: () {
                              if (checkShowLoginModel(context)) {
                                return;
                              }
                            },
                          ),
                        ),
                        Text(22.toString())
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          child: IconButton(
                            icon: const Icon(RemixIcons.message3Line),
                            onPressed: () {},
                          ),
                        ),
                        Text(22.toString())
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          child: IconButton(
                            icon: const Icon(RemixIcons.starLine),
                            onPressed: () {
                              if (checkShowLoginModel(context)) {
                                return;
                              }
                            },
                          ),
                        ),
                        Text(22.toString())
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          child: IconButton(
                            icon: const Icon(RemixIcons.shareForwardLine),
                            onPressed: () {},
                          ),
                        ),
                        Text(22.toString())
                      ],
                    ),
                  )
                ],
              ),
            ]
        ));
      },
      // separatorBuilder: (context, index) => Divider(height: .0),
    );
  }

  void _retrieveData() {
    Future.delayed(const Duration(milliseconds: 300)).then((e) {
      setState(() {
        //重新构建列表
        _words.insertAll(
          _words.length - 1,
          //每次生成20个单词
          generateWordPairs().take(40).map((e) => e.asPascalCase).toList(),
        );
      });
    });
  }

  renderMedia(int index) {
    if (index % 10 < 5) {
      var vedio = _videoList[index % 2];
      if (vedio.url == null || vedio.preview == null) {
        return Text('');
      }
      return SingleAutoPlayVideo(
        video: vedio.url,
        previewPic: vedio.preview,
        horizontal: vedio.horizontal,
        scrollController: widget.scrollController ?? _scrollController,
        tabIndex: widget.tabIndex,
        tabActiveNotifier: widget.tabActiveNotifier,
        informationPageActiveNotifier: widget.informationPageActiveNotifier
      );
    } else {
      return  _urls.length > 0 ? SudokuImages(
        urls: _urls.length > 0 ? _urls.sublist(0, (index + 5) % (_urls.length + 1)) : [],
        position: index,
        userPage: widget.userPage,
      ) : Text('');
    }
  }

  gotoMedia(int index) async {
    if (index % 10 < 5) {
      var vedio = _videoList[index % 2];
      if (vedio.url == null || vedio.preview == null) {
        return null;
      }
      informationPageActiveNotifier.setActive(false);
      await RouteUtil.push(
        context,
        RoutePath.mediaSlidePage,
        params: {
          'type': AssetType.video,
          'onlyMain': widget.userPage,
        },
        // animate: RouteAnimate.swipe,
        swipeEdge: false
      );

    } else {
      informationPageActiveNotifier.setActive(false);
      await RouteUtil.push(
          context,
          RoutePath.mediaSlidePage,
          params: {
            'index': 0,
            'images': _urls.sublist(0, (index + 5) % (_urls.length + 1)),
            'type': AssetType.image,
            'onlyMain': widget.userPage,
          },
          // animate: RouteAnimate.swipe,
          swipeEdge: false
      );
    }
    return null;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}