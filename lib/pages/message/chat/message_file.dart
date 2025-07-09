
import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/constant.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/constant.dart';


class MessageFile extends StatefulWidget {
  final String name;
  final String path;
  final bool isSend;
  final bool isQuote;
  final String quoteNickName;
  final ValueSetter<String> onTap;
  // final bool isStop;

  const MessageFile(
    {
      Key? key,
      required this.path,
      required this.name,
      required this.isSend,
      required this.onTap,
      this.isQuote = false,
      this.quoteNickName = '',
      // required this.isStop
    }
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MessageVoiceState();
  }
}

class MessageVoiceState extends State<MessageFile> {
  List<String> mAudioAssetRightList = [];
  List<String> mAudioAssetLeftList = [];
  final _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late StreamSubscription<void> _playerStateChangedSubscription;

  @override
  void initState() {
    super.initState();
    mAudioAssetRightList.add("${Constant.ASSETS_IMG}audio_animation_list_right_1.png");
    mAudioAssetRightList.add("${Constant.ASSETS_IMG}audio_animation_list_right_2.png");
    mAudioAssetRightList.add("${Constant.ASSETS_IMG}audio_animation_list_right_3.png");

    mAudioAssetLeftList.add("${Constant.ASSETS_IMG}audio_animation_list_left_1.png");
    mAudioAssetLeftList.add("${Constant.ASSETS_IMG}audio_animation_list_left_2.png");
    mAudioAssetLeftList.add("${Constant.ASSETS_IMG}audio_animation_list_right_3.png");

    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
          await stop();
          setState(() {
            isPlaying = false;
          });
        });

  }

  Future<void> play() {
    print('_audioPlayer.play===== ${widget.path}');
    return _audioPlayer.play(
      kIsWeb ? UrlSource(widget.path) : DeviceFileSource(widget.path),
    );
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> resume() => _audioPlayer.resume();

  Future<void> stop() => _audioPlayer.stop();

  double getSoundWidth(duration){
    double width = 0;
    int base = 5;
    if (duration >= 0) {
      width += base * (duration > 10 ? 10 : duration);
    }
    if (duration > 10) {
      width += base / 2 * (duration > 20 ? 10 : (duration - 10));
    }
    if (duration > 20) {
      width += base / 3 * (duration > 30 ? 10 : (duration - 20));
    }
    if (duration > 30) {
      width += base / 5 * (duration - 30);
    }
    return width;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onTap(HrlMessageType.file);

      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        height: widget.isQuote ? 22 : 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.isQuote && widget.quoteNickName != '' ? Expanded(
              flex: 1,
              child: Text(
                '${widget.quoteNickName}：',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isQuote ? ThemeColors.mainGray : ThemeColors.mainBlack,
                ),
                textAlign: TextAlign.start,
              ),
            ) : Container(),
            Expanded(
              flex: 2,
              child: Text(
                widget.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: widget.isQuote ? 12 : 14,
                  color: widget.isQuote ? ThemeColors.mainGray : ThemeColors.mainBlack,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 6),
              child: Icon(Icons.file_open_rounded, size: widget.isQuote ? 22 : 36, color: Colors.green.shade900,),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    // _positionChangedSubscription.cancel();
    // _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}