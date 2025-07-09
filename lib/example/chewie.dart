import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController =  ChewieController(
    videoPlayerController: _controller,
    autoPlay: true,
    looping: true,
  );

  @override
  void initState() {
    print('==================initState');
    super.initState();
    _controller = VideoPlayerController.network(
        'https://video.momocdn.com/feedvideo/17/49/1749BE36-6497-B81C-89EE-3E5BA3544C3D20210505.mp4')
        ..initialize().then((_) {
          print('==================initState222');
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
          _chewieController = ChewieController(
            videoPlayerController: _controller,
            autoPlay: true,
            looping: true,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('==================build');
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _chewieController == null ? Text('loading') : Chewie(
            controller: _chewieController,
          ),
        )
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}