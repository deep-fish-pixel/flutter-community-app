import 'dart:async';
import 'package:file/local.dart';
import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/themes.dart';
import 'package:record/record.dart';

import '../../../../constants/constant.dart';
import 'ImagesAnimation.dart';

OverlayEntry? mOverlayEntry;

String mButtonText = RecordText.pressDown;
String mCenterTipText = "";
const LocalFileSystem mLocalFileSystem = const LocalFileSystem();

double startY = 0.0;
double endY = 0.0;
double offsetY = 0.0;

int mSatrtRecordTime = 0;

// 最短录音时间
int MIN_INTERVAL_TIME = 1000;

String voiceIco = "${Constant.ASSETS_IMG}chat/ic_volume_1.png";

List<String> _assetList = [];

bool showAnim = true;

typedef OnAudioCallBack = void Function(File mAudioFile, int duration);

class RecordButton extends StatefulWidget {
  final OnAudioCallBack onAudioCallBack;

  const RecordButton({
    Key? key,
    required this.onAudioCallBack,
  }) : super(key: key);

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

///显示录音悬浮布局
buildOverLayView(BuildContext context) {
  if (mOverlayEntry == null) {
    mOverlayEntry = OverlayEntry(builder: (content) {
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.5 - 80,
        left: MediaQuery.of(context).size.width * 0.5 - 80,
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Opacity(
              opacity: 0.8,
              child: Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xff77797A),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: showAnim
                            ? VoiceAnimationImage(
                                _assetList,
                                width: 100,
                                height: 100,
                                isStop: true,
                              )
                            : Image.asset(
                                voiceIco,
                                width: 100,
                                height: 100,
                              )),
                    Container(
                     padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        mCenterTipText,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: mCenterTipText == RecordText.upDrop ? ThemeColors.main : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
    Overlay.of(context)?.insert(mOverlayEntry!);
  }
}

Map<int, Image> imageCaches = Map();


class RecordText {
  static const String pressDown = '按住录音';
  static const String upSend = '松开发送';
  static const String drapUpCancel = '手指上滑, 取消发送';
  static const String upDrop = '松开手指, 取消发送';
  static const String tooSmall = '录音时间太短';
}

class _RecordButtonState extends State<RecordButton> {
  Record _audioRecorder = Record();

  initRecord(){
    _audioRecorder = Record();
  }

  Future<void> startRecord() async {
    print("开始录音");
    initRecord();

    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();
      }
    } catch (e) {
      print(e);
    }
  }


  cancelRecord() async {
    String? recording;
    File? file;
    try {
      recording = await _audioRecorder.stop();
      if (recording != null) {
        file = mLocalFileSystem.file(recording);
      }
    } catch (e) {
      // 任意一个异常
      print('Unknown exception: $e');
    }
    file?.delete();
    print("取消录音删除文件成功!");
    mOverlayEntry?.remove();
    mOverlayEntry = null;
    setState(() {
    });
  }

  completeRecord() async {
    int intervalTime =
        DateTime.now().millisecondsSinceEpoch - mSatrtRecordTime;
    String? recording;
    File? file;
    try {
      recording = await _audioRecorder.stop();
      if (recording != null) {
        file = mLocalFileSystem.file(recording);
      }
    } catch (e) {
      // 任意一个异常
      print('Unknown exception: $e');
    }


    if (intervalTime < MIN_INTERVAL_TIME) {
      print(RecordText.tooSmall);
      mCenterTipText = RecordText.tooSmall;
      voiceIco = "${Constant.ASSETS_IMG}chat/ic_volume_wraning.png";
      showAnim = false;
      mButtonText = RecordText.pressDown;
      mOverlayEntry?.markNeedsBuild();
      file?.delete();
      print("${RecordText.tooSmall}:删除文件成功!");
      Future.delayed(const Duration(milliseconds: 500), () {
        mOverlayEntry?.remove();
        mOverlayEntry = null;
      });
    } else {
      print("录音完成");
      print("Stop recording: $recording");
      print("  File length: ${(intervalTime/1000).round()}");

      mOverlayEntry?.remove();
      mOverlayEntry = null;
      widget.onAudioCallBack.call(file!, (intervalTime/1000).round());
    }
  }

  bool flag = true; // member variable

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assetList.add("${Constant.ASSETS_IMG}chat/ic_volume_1.png");
    _assetList.add("${Constant.ASSETS_IMG}chat/ic_volume_2.png");
    _assetList.add("${Constant.ASSETS_IMG}chat/ic_volume_3.png");
    _assetList.add("${Constant.ASSETS_IMG}chat/ic_volume_4.png");
    _assetList.add("${Constant.ASSETS_IMG}chat/ic_volume_5.png");
  }

  double startY = 0.0;
  double endY = 0.0;
  double offsetY = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        mCenterTipText = RecordText.drapUpCancel;
        mButtonText = RecordText.upSend;
        showAnim = true;
        buildOverLayView(context);
        setState(() {});
        startRecord();
        startY = details.globalPosition.dy;
        mSatrtRecordTime = DateTime.now().millisecondsSinceEpoch;
      },
      onVerticalDragEnd: (details) {
        setState(() {
          mButtonText = RecordText.pressDown;
        });
        if (offsetY >= 60) {
          print("执行取消录音:" + offsetY.toString());
          cancelRecord();
        } else {
          completeRecord();
        }
      },
      onVerticalDragUpdate: (details) {
        endY = details.globalPosition.dy;
        offsetY = startY - endY;
        print("偏移量是:" + "($offsetY)");
        if (offsetY >= 60) {
          //当手指向上滑，会cancel
          mCenterTipText = RecordText.upDrop;
          voiceIco = "${Constant.ASSETS_IMG}chat/ic_volume_cancel2.png";
          showAnim = false;
          mOverlayEntry?.markNeedsBuild();
          setState(() {
            mButtonText = RecordText.upDrop;
          });
        } else {
          mCenterTipText = RecordText.drapUpCancel;
          mButtonText = RecordText.upSend;
          showAnim = true;
          mOverlayEntry?.markNeedsBuild();
        }
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: const Color(0xffFEFFFE),
        ),
        child: Center(
          child: Text(
            mButtonText,
          ),
        ),
      ),
    );
  }
}
