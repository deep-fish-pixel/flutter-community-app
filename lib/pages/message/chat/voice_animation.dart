
import 'package:flutter/material.dart';
import 'package:gardener/constants/themes.dart';


class VoiceAnimationImage extends StatefulWidget {
  final List<String> _assetList;
  final double height;
  int? interval = 300;
  bool? isStop = true;
  var callStart;
  VoiceAnimationImageState voiceAnimationImageState = VoiceAnimationImageState();

  VoiceAnimationImage(
    this._assetList,
    {
      Key? key,
      required this.height,
      this.isStop,
      this.interval
    }
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return voiceAnimationImageState;
  }

  start() {
    voiceAnimationImageState.start();
  }

  stop() {
    voiceAnimationImageState.stop();
  }
}

class VoiceAnimationImageState extends State<VoiceAnimationImage>
    with SingleTickerProviderStateMixin {
  // 动画控制
  late Animation<double> _animation;
  late AnimationController _controller;
  int interval = 300;

  @override
  void initState() {
    super.initState();

    if (widget.interval != null) {
      interval = widget.interval!;
    }
    final int imageCount = widget._assetList.length;
    final int maxTime = interval * imageCount;

    // 启动动画controller
    _controller = AnimationController(
        duration: Duration(milliseconds: maxTime), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _controller.forward(from: 0.0); // 完成后重新开始
      }
    });

    _animation = Tween<double>(begin: 0, end: imageCount.toDouble())
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  stop() {
    _controller.stop();
  }

  start() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> images = [];

    if (widget.isStop == true) {
      stop();
      int ix = 2;
      // 把所有图片都加载进内容，否则每一帧加载时会卡顿
      for (int i = 0; i < widget._assetList.length; ++i) {
        if (i != ix) {
          images.add(Image.asset(
            widget._assetList[i],
            width: 0,
            height: 0,
          ));
        }
      }
      images.add(Image.asset(
        widget._assetList[ix],
        width: 30,
        height: 20,
      ));
    } else {
      start();
      int ix = _animation.value.floor() % widget._assetList.length;
      // 把所有图片都加载进内容，否则每一帧加载时会卡顿
      for (int i = 0; i < widget._assetList.length; ++i) {
        if (i != ix) {
          images.add(Image.asset(
            widget._assetList[i],
            width: 0,
            height: 0,
          ));
        }
      }
      images.add(Image.asset(
        widget._assetList[ix],
        width: 30,
        height: 20,
      ));
    }

    return Container(
      height: 20,
      alignment: Alignment.centerRight,
      child: Stack(children: images),
    );
  }
}