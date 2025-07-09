import 'package:flutter/material.dart';
import 'package:gardener/pages/information/components/bottom_bar.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/media_user_info.dart';
import 'package:gardener/pages/mine/user-page.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_video_page.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/style/physics.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_scaffold.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_tab_bar.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/controller/tikTok_video_list_controller.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/util/win_media.dart';
import 'package:video_player/video_player.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_header.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/pages/msg_page.dart';

import 'components/video/tiktok/mock/media.dart';
import 'components/video/tiktok/views/tiktok_image_page.dart';

class MediaSlidePage extends StatefulWidget {
  const MediaSlidePage({super.key});

  @override
  _MediaSlidePageState createState() => _MediaSlidePageState();
}

class _MediaSlidePageState extends State<MediaSlidePage> with WidgetsBindingObserver {
  TikTokPageTag tabBarType = TikTokPageTag.home;

  TikTokScaffoldController tkController = TikTokScaffoldController();

  final PageController _pageController = PageController();

  final TikTokVideoListController _videoListController = TikTokVideoListController();

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List<UserMedia> mediaDataList = [];

  bool disposed = false;

  var mediaParams;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  activate(){
    mediaDataList = UserMedia.fetchMedia(type: mediaParams != null ? mediaParams['type'] : '');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoListController.currentPlayer.pause();
    informationPageActiveNotifier.setActive(true);
    disposed = true;
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    tkController.addListener(
          () {
        if (tkController.value == TikTokPagePositon.middle) {
          _videoListController.currentPlayer.play();
        } else {
          _videoListController.currentPlayer.pause();
        }
      },
    );

    Future.delayed(const Duration(milliseconds: 10), fetch);

    super.initState();
  }


  fetch() {
    mediaDataList = UserMedia.fetchMedia(type: mediaParams != null ? mediaParams['type'] : '');
    _videoListController.init(
      pageController: _pageController,
      initialList: mediaDataList
          .map((e) {
        if (e.isVideo()) {
          return VPVideoController(
            mediaInfo: e,
            builder: () => VideoPlayerController.network(e.url!),
          );
        }
        return VPImageController(
          mediaInfo: e,
          builder: () => ImagePlayerController(),
        );
      }
      ).toList(),
      videoProvider: (int index, List<TikTokMediaController> list) async {
        return mediaDataList
            .map((e){
          if (e.isVideo()) {
            return VPVideoController(
              mediaInfo: e,
              builder: () => VideoPlayerController.network(e.url!),
            );
          }
          return VPImageController(
            mediaInfo: e,
            builder: () => ImagePlayerController(),
          );
        }).toList();
      },
    );
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    Widget? currentPage;
    winHeight(context);
    mediaParams = RouteUtil.getParams(context);
    print('mediaParams================' + mediaParams.toString());

    if (mediaDataList.isEmpty) {
      return Container();
    }



    switch (tabBarType) {
      case TikTokPageTag.home:
        break;
      case TikTokPageTag.follow:
        // currentPage = FollowPage();
        break;
      case TikTokPageTag.msg:
        currentPage = MsgPage();
        break;
      case TikTokPageTag.me:
        currentPage = UserPage();
        break;
    }
    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;

    var userPage = UserPage(
      canPop: true,
      onPop: () {
        tkController.animateToMiddle();
        print('userPage onPop==================');
      },
    );

    var header = tabBarType == TikTokPageTag.home
        ? TikTokHeader(
      onSearch: () {
        // tkController.animateToLeft();
        print('====================${Navigator.canPop(context)}');
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
    ) : Container();

    // 组合
    return TikTokScaffold(
      controller: tkController,
      hasBottomPadding: false,
      header: header,
      rightPage: userPage,
      enableGesture: true,
      onlyMain: mediaParams['onlyMain'],
      // onPullDownRefresh: _fetchData,
      page: Stack(
        // index: currentPage == null ? 0 : 1,
        children: <Widget>[
          PageView.builder(
            key: Key('home'),
            physics: QuickerScrollPhysics(),
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _videoListController.videoCount,
            itemBuilder: (context, index) {
              // 用户操作按钮组
              Widget buttons = BottomBar();

              var player = _videoListController.playerOfIndex(index)!;

              if (_videoListController.playerOfIndex(index)?.isVideo() == true) {
                var data = player.mediaInfo;
                return TikTokVideoPage(
                  player: player as VPVideoController,
                  aspectRatio: 9 / 16.0,
                  key: Key('${data.url!}$index'),
                  tag: data.url,
                  bottomPadding: hasBottomPadding ? 16.0 : 16.0,
                  userInfoWidget: MediaUserInfo(
                    desc: data.desc,
                    bottomPadding: 16.0,
                  ),
                  onAddFavorite: () {
                    setState(() {
                      favoriteMap[index] = true;
                    });
                  },
                  bottomButtons: buttons,
                  video: VideoPlayer(player.controller),
                  videoProgress: VideoProgressIndicator(
                    player.controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Color(0xFFF44336),
                      bufferedColor: Color.fromRGBO(230, 230, 230, 0.7),
                      backgroundColor: Color.fromRGBO(210, 210, 210, 0.7),
                    )
                  ),
                );
              } else {
                return TikTokImagePage(
                  player: player as VPImageController,
                  mediaInfo: player.mediaInfo,
                  userInfoWidget: const MediaUserInfo(
                    bottomPadding: 16.0,
                  ),
                  bottomButtons: buttons,
                  selectedIndex: index == 0 ? (mediaParams != null ? mediaParams['index'] : 0) : 0
                );
              }
            },
          ),
          currentPage ?? Container(),
        ],
      ),
    );
  }
}
