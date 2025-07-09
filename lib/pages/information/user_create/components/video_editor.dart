import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/util/win_media.dart';
import 'package:video_player/video_player.dart';

class VideoEditor extends StatefulWidget {
  final String video;
  final TabActiveNotifier? tabActiveNotifier;
  final InformationPageActiveNotifier? informationPageActiveNotifier;

  const VideoEditor({
    Key? key,
    required this.video,
    this.tabActiveNotifier,
    this.informationPageActiveNotifier
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SingleVideoViewState();
  }
}

class _SingleVideoViewState extends State<VideoEditor> {
  late VideoPlayerController _controller;
  bool _isReady = false;
  bool _isPlaying = false;
  bool sized = false;
  late Size size;
  late double offsetX;
  late double offsetY;
  late double scrollPosition;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.video))
      ..initialize().then((_) {
        setState(() {
          _isReady = true;
        });
      });
    _controller.addListener(() {
      if ( _isPlaying != _controller.value.isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });

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
    final size = winWidthFromCache();
    if(widget.video.isNotEmpty){
      if (_isReady) {
        var imageHeight = size / 2;

        return Container(
          alignment: Alignment.topLeft,
          height: imageHeight / _controller.value.aspectRatio,
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: ClipRRect( //剪裁为圆角矩形 1.78
            borderRadius: BorderRadius.circular(5.0),
            child: renderVideo(),
          ),
        );
      }

    }
    return Text('');
  }

  Widget renderVideo(){
    print('renderVideo=================');
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
            ),
            _isPlaying ?  Container() : GestureDetector(
              onTap: () {
                play();
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: Icon(
                  RemixIcons.playCircleFill,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  void dispose() {
    print('================ VideoEditor dispose');
    super.dispose();
    _controller.dispose();
  }
}

