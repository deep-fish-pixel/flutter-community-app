import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/pages/information/components/bottom_bar.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/controller/tikTok_video_list_controller.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/style/style.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_comment_bottom_sheet.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_video_gesture.dart';
import 'package:gardener/util/win_media.dart';
import 'package:video_player/video_player.dart';

///
/// TikTok风格的一个视频页组件，覆盖在video上，提供以下功能：
/// 播放按钮的遮罩
/// 单击事件
/// 点赞事件回调（每次）
/// 长宽比控制
/// 底部padding（用于适配有沉浸式底部状态栏时）
///

class TikTokVideoPage extends StatefulWidget {
  final Widget? video;
  final double aspectRatio;
  final String? tag;
  final double bottomPadding;

  final Widget? bottomButtons;
  final Widget? userInfoWidget;

  final Function? onAddFavorite;
  final Function? onSingleTap;
  final VideoProgressIndicator? videoProgress;
  final VPVideoController player;

  const TikTokVideoPage({
    Key? key,
    this.bottomPadding: 16,
    this.tag,
    this.bottomButtons,
    this.userInfoWidget,
    this.onAddFavorite,
    this.onSingleTap,
    this.video,
    this.aspectRatio: 9 / 16.0,
    this.videoProgress,
    required this.player,
  }) : super(key: key);

  @override
  _TikTokVideoPageState createState() {
    return _TikTokVideoPageState();
  }

}
class _TikTokVideoPageState extends State<TikTokVideoPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _bottomHeight = 0;
  bool showComments = false;
  bool _manualOperationPause = false;
  late double aspectRatio;

  @override
  void initState() {
    super.initState();
    _animationController =  AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: winHeightFromCache() * 0.7
    )
    ..addStatusListener((AnimationStatus status) {
      print('_animationController=======status $status');
      if(status == AnimationStatus.completed){
        // setState(() => showComments = true);
      }else if(status == AnimationStatus.dismissed){
        setState(() => showComments = false);
      }
    })
    ..addListener(() {
      setState(() {
        _bottomHeight = _animationController.value;
      });
    });
    widget.player.addListener(() {
      if (widget.player.changeValue == PlayerChangeType.playing) {
        _manualOperationPause = false;
      }
    });
    aspectRatio = widget.player.controller.value.aspectRatio;
    widget.player.controller.addListener(handlePlayer);
  }

  handlePlayer(){
    if (aspectRatio != widget.player.controller.value.aspectRatio) {
      print('widget.player.controller=====22222==============' + widget.player.controller.value.aspectRatio.toString());
      setState(() => {});
      aspectRatio = widget.player.controller.value.aspectRatio;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 视频播放页
    Widget videoContainer = Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          alignment: Alignment.center,
          child: Center(
            child: AspectRatio(
              aspectRatio: widget.player.controller.value.aspectRatio,
              child: VideoPlayer(widget.player.controller),
            ),
          ),
        ),
        _manualOperationPause && widget.player.showPauseIcon.value ? Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: Icon(
            RemixIcons.playCircleFill,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
        ) : Container(),
        showComments ? GestureDetector(
          onTap: (){
            _animationController.reverse();
          },
          child: Container(
            color: Colors.white.withOpacity(0.01),
            height: double.infinity,
            width: double.infinity,
          ),
        ) : TikTokVideoGesture(
          onAddFavorite: widget.onAddFavorite,
          onSingleTap: () async {
            if (widget.player.controller.value.isPlaying) {
              _manualOperationPause = true;
              await widget.player.pause();
            } else {
              _manualOperationPause = false;
              await widget.player.play();
            }
            setState(() {

            });
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: videoContainer,
                ),
              )
            ],
          ),
          showComments || widget.userInfoWidget == null ? Container() : Container(
            alignment: Alignment.bottomLeft,
            child: widget.userInfoWidget,
          ),
          showComments ?  Container(
            height: 4,
          ) : widget.videoProgress ?? Container(),
        ],
      ),
    );
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
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
                      print('onShowComments ========_animationController');
                      _animationController.forward();
                      setState(() => showComments = true);
                    }
                ),
              ),
              Container(
                child: BottomSheet(
                  animationController: _animationController,
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
    );;
  }

  @override
  void dispose() {
    super.dispose();
    print('disposedisposedisposedisposedisposedisposedispose======_animationController');
    _animationController.stop();
    _animationController.dispose();
    widget.player.dispose();
    widget.player.controller.removeListener(handlePlayer);
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


