import 'package:flutter/material.dart';
import 'package:gardener/components/PositionContainer.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/win_media.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class SingleAutoPlayVideo extends StatefulWidget {
  final String video;
  final String previewPic;
  final bool horizontal;
  final int tabIndex;
  final ScrollController scrollController;
  final TabActiveNotifier? tabActiveNotifier;
  final InformationPageActiveNotifier? informationPageActiveNotifier;

  const SingleAutoPlayVideo({
    Key? key,
    required this.video,
    required this.previewPic,
    required this.horizontal,
    required this.scrollController,
    this.tabIndex = -1,
    this.tabActiveNotifier,
    this.informationPageActiveNotifier
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SingleVideoViewState();
  }
}

class _SingleVideoViewState extends State<SingleAutoPlayVideo> {
  late VideoPlayerController _controller;
  bool _isReady = false;
  bool sized = false;
  late Size size;
  late double offsetX;
  late double offsetY;
  late double scrollPosition;


  @override
  void initState() {
    super.initState();
    scrollPosition = getScrollPosition().pixels;
    _controller = VideoPlayerController.network(widget.video)
      ..setVolume(0)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _isReady = true;
        });
      });
    widget.scrollController.addListener(_scrollListener);
    widget.tabActiveNotifier?.addListener(_tabAcitveListener);
    widget.informationPageActiveNotifier?.addListener(_tabAcitveListener);
  }

  getScrollPosition(){
    if (widget.tabIndex >= 0 && widget.tabIndex < widget.scrollController.positions.length) {
      return widget.scrollController.positions.elementAt(widget.tabIndex);
    }
    return widget.scrollController.position;
  }

  _scrollListener() {
    if (!sized) {
      return;
    }


    double scrolledY = scrollPosition - getScrollPosition().pixels;
    double currentPositionY = offsetY + scrolledY;
    double screenHeight = winHeightFromCache();
    print('widget.scrollController.position.pixels======' + getScrollPosition().pixels.toString()
        + ' currentPositionY====' + currentPositionY.toString()
        + ' scrollPosition====' + scrollPosition.toString()
        + ' offsetY====' + offsetY.toString()
        + ' screenHeight====' + screenHeight.toString()
    );
    if ((currentPositionY < screenHeight * (5 / 10) + 0) && (currentPositionY >= 30 + 0)) {
      play();
    } else {
      pause();
    }
  }

  _tabAcitveListener(){
    if (widget.tabActiveNotifier == null || widget.informationPageActiveNotifier == null) {
      return;
    }
    if (!widget.informationPageActiveNotifier?.getActive() ||
          widget.tabIndex != widget.tabActiveNotifier?.getTabIndex()) {
      return pause();
    }
    if (widget.tabIndex == widget.tabActiveNotifier?.getTabIndex() || widget.informationPageActiveNotifier?.getActive()) {
      print('_tabAcitveListener _informationAcitveListener===================' + widget.hashCode.toString());
      return _scrollListener();
    }
  }

  play(){
    if(_isReady) {
      _controller.play();
    }
  }

  pause(){
    if(_isReady) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    var previewPic = widget.previewPic;
    var horizontal = widget.horizontal;
    if(widget.video.isNotEmpty && previewPic.isNotEmpty){
      if (_isReady) {
        var imageHeight = horizontal ? 380.0 : 250.0;

        return PositionContainer(
          child: Container(
            alignment: Alignment.topLeft,
            height: imageHeight / _controller.value.aspectRatio,
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: ClipRRect( //剪裁为圆角矩形 1.78
              borderRadius: BorderRadius.circular(5.0),
              child: renderVideo(),
            ),
          ),
          getSize: (Size size, double offsetX, double offsetY){
            this.sized = true;
            this.size = size;
            this.offsetX = offsetX;
            this.offsetY = offsetY;
            scrollPosition = getScrollPosition().pixels;
            _scrollListener();
            // print('getSize=================$size $offsetY $scrollPosition ${widget.video}');
          }
        );
      } else {
        return Container(
          alignment: Alignment.topLeft,
          child: renderImage(previewPic, horizontal, width),
        );
      }

    }
    return Text('');
  }

  Widget renderVideo(){
    if (_controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            VideoPlayer(_controller),
            VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Color(0xFFF44336),
                  bufferedColor: Color.fromRGBO(210, 210, 210, 0.7),
                  backgroundColor: Color.fromRGBO(170, 170, 170, 0.7),
                )
            )
          ],
        ),
      );
    }
    return Container();
  }

  Stack renderImage(String previewPic, bool horizontal, double width) {
    var imageHeight = horizontal ? 250 : 380;

    return Stack(
      alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
      children: <Widget>[
        Padding(
          // 分别指定四个方向的补白
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: ClipRRect( //剪裁为圆角矩形
            borderRadius: BorderRadius.circular(5.0),
            child: GestureDetector(
              onTap: _onClick,//写入方法名称就可以了，但是是无参的
              child: Image(
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  height: imageHeight * width / 411,
                  image: NetworkImage(previewPic)
              ),
            ),
          )
        ),
        Positioned(
          child: GestureDetector(
            onTap: _onClick,//写入方法名称就可以了，但是是无参的
            child: Image.asset("assets/images/play_btn.png",
              width: 70.0,
            ),
          ),

        )
    ]);
  }


  void _onClick() {
    pause();
    RouteUtil.push(context, RoutePath.mediaSlidePage, params: {
      'type': AssetType.video
    });
  }


  @override
  void dispose() {
    print('================ SingleAutoPlayVideo dispose');
    super.dispose();
    widget.scrollController.removeListener(_scrollListener);
    widget.tabActiveNotifier?.removeListener(_tabAcitveListener);
    widget.informationPageActiveNotifier?.removeListener(_tabAcitveListener);
    _controller.dispose();

  }

  void activate(){
    print('activate==========================');
    _scrollListener();
  }

  void deactivate(){
    print('deactivate==========================');
    // pause();
  }

}

// video
/*1
https://img.momocdn.com/feedvideo/52/EB/52EB14BD-415C-B0FF-A841-7E91B074029F20220818_L.jpg
https://video.momocdn.com/feedvideo/74/2B/742BEF3B-D0C6-DDFE-03FE-9C4C75E863B520220818.mp4
*/


/*
https://img.momocdn.com/feedvideo/D2/B9/D2B97E3A-9A18-022F-FE0C-43150374E46D20210506_L.jpg
https://video.momocdn.com/feedvideo/17/49/1749BE36-6497-B81C-89EE-3E5BA3544C3D20210505.mp4
* */


