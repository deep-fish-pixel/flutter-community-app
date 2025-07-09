import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gardener/components/information/process_swiper_pagination_builder.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/pages/information/components/bottom_bar.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/controller/tikTok_video_list_controller.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/mock/media.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/style/style.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/animation_controllers.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_comment_bottom_sheet.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_video_gesture.dart';
import 'package:gardener/util/win_media.dart';

///
/// TikTok风格的一个视频页组件，覆盖在video上，提供以下功能：
/// 播放按钮的遮罩
/// 单击事件
/// 点赞事件回调（每次）
/// 长宽比控制
/// 底部padding（用于适配有沉浸式底部状态栏时）
///
class TikTokImagePage extends StatefulWidget {
  final UserMedia mediaInfo;
  final String? tag;
  final double bottomPadding;
  final int selectedIndex;

  final Widget? bottomButtons;
  final Widget? userInfoWidget;
  final VPImageController? player;


  final Function? onAddFavorite;
  final Function? onSingleTap;

  const TikTokImagePage({
    Key? key,
    this.bottomPadding = 16,
    this.selectedIndex = 0,
    this.tag,
    this.bottomButtons,
    this.userInfoWidget,
    this.onAddFavorite,
    this.onSingleTap,
    required this.mediaInfo,
    required this.player
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TikTokImagePageState();
  }

}


const images = <String>[
  'https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/65e1e8689e829901b04b1bfa5ba96a40-sz_139219.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/4cf7841f92d13a67c0f25738ba1d3266-sz_125868.jpg?x-oss-process=style/xmwebp',
  // 'https://img.xiumi.us/xmi/ua/3wa69/i/3553a9363cf990862c6f236559fc98ca-sz_195633.jpg?x-oss-process=style/xmwebp',
  // 'https://img.xiumi.us/xmi/ua/3wa69/i/73414e98d6debe9f42526875cb8658cf-sz_224834.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_1050,w_1050,x_0,y_175/format,webp',
  // 'https://img.xiumi.us/xmi/ua/3wa69/i/f80f3fc92d07972d039c74b8475ea562-sz_193955.jpg?x-oss-process=style/xmwebp',
  // 'https://img.xiumi.us/xmi/ua/3wa69/i/69eb48fe55532c85934cdf24807fc3f8-sz_181952.jpg?x-oss-process=style/xmwebp',
  // 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F0814%2F17c8e8c3c106b879aa9f4e9189601c3b.jpg&refer=http%3A%2F%2Ffile02.16sucai.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663541917&t=a9a98cdae0ef8d8c280fe105ac01f852'
];


class _TikTokImagePageState extends State<TikTokImagePage> with TickerProviderStateMixin {
  late AnimationController _animationCommentController;
  late SwiperController _swiperController;
  late AnimationControllers _animationControllers;
  ImagePlayerController? _imagePlayerController;
  
  double _bottomHeight = 0;
  int _swiperIndex = 0;
  bool _showComments = false;
  bool _autoplay = false;
  bool _manualOperationPause = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    _swiperIndex = widget.selectedIndex;

    _animationCommentController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0,
        upperBound: winHeightFromCache() * 0.7
      )
      ..addStatusListener((AnimationStatus status) {
        print('_animationCommentController=======status $status');
        if(status == AnimationStatus.completed){
          // setState(() => _showComments = true);
        }else if(status == AnimationStatus.dismissed){
          setState(() => _showComments = false);
        }
      })
      ..addListener(() {
        setState(() {
          _bottomHeight = _animationCommentController.value;
        });
      });
    _swiperController = SwiperController();
    _imagePlayerController = widget.player?.getController();
    widget.player?.setSwiperController(_swiperController);

    double upperBound = (winWidthFromCache() - 20) / max(images.length, 1);
    _animationControllers = AnimationControllers(
      length: images.length,
      currentIndex: _swiperIndex + 1, // 需要加1，避免process减1
      itemBuilder: (index) {
        return AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2 * 1000),
          value: index < _swiperIndex ? upperBound : 0,
          lowerBound: 0,
          upperBound: upperBound
        );
      },
      swiperController: _swiperController
    );

    _swiperController.addListener(() {
      if (_disposed) {
        return;
      }
      var event = _swiperController.event;
      if (event is AutoPlaySwiperControllerEvent) {
        if(event.animation){
          if (_autoplay != event.autoplay) {
            setState(() {
              _autoplay = event.autoplay;
            });
            if (event.autoplay) {
              _manualOperationPause = false;
            }
          }
        }
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {

    // 视频加载的动画
    // Widget videoLoading = VideoLoadingPlaceHolder(tag: tag);
    // 视频播放页
    Widget videoContainer = Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          alignment: Alignment.center,
          child: Container(
              child: Swiper(
                itemBuilder: (context, index) {
                  _swiperIndex = index;
                  print('itemBuilder===================_swiperIndex=' + _swiperIndex.toString());
                  final image = images[index];
                  return Image(
                      alignment: Alignment.center,
                      image: NetworkImage(image)
                  );
                },
                indicatorLayout: PageIndicatorLayout.NONE,
                itemCount: images.length,
                index: _swiperIndex,
                autoplay: false,
                autoplayDelay: 2000,
                controller: _swiperController,
                pagination: SwiperCustomPagination(
                  builder:(BuildContext context, SwiperPluginConfig config){
                    print('SwiperPluginConfig config==========' + config.activeIndex.toString());
                    _swiperIndex = config.activeIndex;

                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: _showComments ? 0 : 1,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 1),
                          child: ProcessSwiperPagination(
                              animationControllers: _animationControllers,
                              color: Colors.grey.shade300,
                              config: config
                          ),
                        ),
                      ),
                    );
                  },
                )
              )
          ),
        ),

        !_autoplay && _manualOperationPause ? Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: Icon(
            RemixIcons.playCircleFill,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
        ) : Container(),
        _showComments ? GestureDetector(
          onTap: (){
            _animationCommentController.reverse();
          },
          child: Container(
            color: Colors.white.withOpacity(0.01),
            height: double.infinity,
            width: double.infinity,
          ),
        ) : TikTokVideoGesture(
          onAddFavorite: widget.onAddFavorite,
          onSingleTap: (){
            if (_autoplay) {
              _manualOperationPause = true;
              _swiperController.stopAutoplay();
              _animationControllers.pause();
            } else {
              _manualOperationPause = false;
              _swiperController.startAutoplay();
            }

            if(widget.onSingleTap != null) {
              widget.onSingleTap!();
            }
          },
          child: Container(
            color: ColorPlate.clear,
            height: double.infinity,
            width: double.infinity,
          ),
        )
      ],
    );
    Widget body = Container(
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          videoContainer,
          _showComments || widget.userInfoWidget == null ? Container() : Container(
            alignment: Alignment.bottomLeft,
            child: widget.userInfoWidget,
          ),
        ],
      ),
    );
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: body,
            ),
          ),
          Stack(
            children: [
              Container(
                color: Colors.black,
                alignment: Alignment.bottomRight,
                child: BottomBar(
                    onShowComments: (){
                      print('onShowComments ========_animationCommentController');
                      _animationCommentController.forward();
                      setState(() => _showComments = true);
                    }
                ),
              ),
              Container(
                child: BottomSheet(
                  animationController: _animationCommentController,
                  builder: (BuildContext context) {
                    return Container(
                      height: _bottomHeight,
                      color: Colors.black,
                      child: const TikTokCommentBottomSheet(),
                    );
                  },
                  onClosing: () {

                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('disposedisposedisposedisposedisposedisposedispose======_animationCommentController');
    _animationCommentController.stop();
    _animationCommentController.dispose();
    _animationControllers.dispose();
    _imagePlayerController?.dispose();
    _disposed = true;
    super.dispose();
  }
}

class VideoLoadingPlaceHolder extends StatelessWidget {
  const VideoLoadingPlaceHolder({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: <Color>[
            Colors.blue,
            Colors.green,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitWave(
            size: 36,
            color: Colors.white.withOpacity(0.3),
          ),
          Container(
            padding: EdgeInsets.all(50),
            child: Text(
              tag,
              style: StandardTextStyle.normalWithOpacity,
            ),
          ),
        ],
      ),
    );
  }
}






