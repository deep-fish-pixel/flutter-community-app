import 'package:flutter/material.dart';
import 'package:gardener/pages/mine/user-page.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_scaffold.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_tab_bar.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/controller/tikTok_video_list_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/mock/video.dart';

class SlideMinePage extends StatefulWidget {
  @override
  _SlideVideoPageState createState() => _SlideVideoPageState();
}

class _SlideVideoPageState extends State<SlideMinePage> with WidgetsBindingObserver {
  TikTokPageTag tabBarType = TikTokPageTag.home;

  TikTokScaffoldController tkController = TikTokScaffoldController();

  PageController _pageController = PageController();

  TikTokVideoListController _videoListController = TikTokVideoListController();

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List<UserVideo> videoDataList = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoListController.currentPlayer.pause();
    super.dispose();
  }

  @override
  void initState() {
    videoDataList = UserVideo.fetchVideo();
    WidgetsBinding.instance.addObserver(this);
    _videoListController.init(
      pageController: _pageController,
      initialList: videoDataList
          .map(
            (e) => VPVideoController(
              videoInfo: e,
              builder: () => VideoPlayerController.network(e.url),
            ),
          )
          .toList(),
      videoProvider: (int index, List<VPVideoController> list) async {
        return videoDataList
            .map(
              (e) => VPVideoController(
                videoInfo: e,
                builder: () => VideoPlayerController.network(e.url),
              ),
            )
            .toList();
      },
    );
    _videoListController.addListener(() {
      setState(() {});
    });
    tkController.addListener(
      () {
        if (tkController.value == TikTokPagePositon.middle) {
          _videoListController.currentPlayer.play();
        } else {
          _videoListController.currentPlayer.pause();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? currentPage;

    switch (tabBarType) {
      case TikTokPageTag.home:
        break;
      case TikTokPageTag.me:
        currentPage = UserPage();
        break;
    }
    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;

    bool hasBackground = hasBottomPadding;
    hasBackground = tabBarType != TikTokPageTag.home;
    if (hasBottomPadding) {
      hasBackground = true;
    }

    var userPage = UserPage(
      canPop: true,
      onPop: () {
        tkController.animateToMiddle();
      },
    );

    // 组合
    return TikTokScaffold(
      controller: tkController,
      hasBottomPadding: hasBackground,
      header: Container(),
      rightPage: userPage,
      enableGesture: tabBarType == TikTokPageTag.home,
      // onPullDownRefresh: _fetchData,
      page: Stack(
        // index: currentPage == null ? 0 : 1,
        children: <Widget>[
          UserPage(),
          currentPage ?? Container(),
        ],
      ),
    );
  }
}
