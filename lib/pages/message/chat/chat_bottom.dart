import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gardener/constants/chat_constant.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/message/message_normal.dart';
import 'package:gardener/pages/message/chat/record_button.dart';
import 'package:gardener/util/event_bus.dart';
import 'package:gardener/util/height_reporter.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../constants/constant.dart';
import '../../../../util/sp_util.dart';
import 'chat_more_page.dart';
import 'emoji_widget.dart';
import 'extra_widget.dart';
import 'image_button.dart';


typedef void OnSend(String text);
typedef void OnImageSelect(List<AssetEntity> assetEntities);
typedef void OnFileSelect(List<File> assetEntities);

typedef void OnAudioCallBack(File mAudioFile, int duration);

const Color bottomBackgroundColor = Color(0xffF6F7F6);

class ChatBottomInputWidget extends StatefulWidget {
  final OnSend? onSendCallBack;

  final OnImageSelect? onSelectedImageCallBack;

  final OnFileSelect? onSelectedFileCallBack;

  final OnAudioCallBack? onAudioCallBack;

  final Stream shouldTriggerChange;
  final HrlMessage? currentMessage;

  Function(double softKeyMaxHeight)? onHeightChange;

  ChatBottomInputWidget({
    Key? key,
    required this.shouldTriggerChange,
    this.onSendCallBack,
    this.onSelectedImageCallBack,
    this.onSelectedFileCallBack,
    this.onAudioCallBack,
    this.onHeightChange,
    this.currentMessage,
  }) : super(key: key);

  @override
  _ChatBottomInputWidgetState createState() => _ChatBottomInputWidgetState();
}

class _ChatBottomInputWidgetState extends State<ChatBottomInputWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  String mCurrentType = KeyboardInputType.text;

  FocusNode mEditFocusNode = FocusNode();
  DateTime mEditFocusTime = DateTime.now();

  TextEditingController mEditController = TextEditingController();

  StreamController<String> inputContentStreamController = StreamController.broadcast();

  Stream<String> get inputContentStream => inputContentStreamController.stream;

  final GlobalKey globalKey = GlobalKey();

  double _softKeyHeight = SpUtil.getDouble(Constant.SP_KEYBOARD_HEGIHT, 320);
  double _softKeyMaxHeight = SpUtil.getDouble(Constant.SP_KEYBOARD_HEGIHT, 320);
  double _mEditHeight = 40;
  bool mAddLayoutShow = false;
  bool mEmojiLayoutShow = false;

  Widget bottomItemCache = Container();

  StreamSubscription? keyboardShowStream;

  /*KeyboardVisibilityNotification _keyboardVisibility =
      KeyboardVisibilityNotification();*/

  late StreamSubscription streamSubscription;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void didChangeMetrics() {
    final mediaQueryData = MediaQueryData.fromWindow(ui.window);
    final keyHeight = mediaQueryData.viewInsets.bottom;
    if (keyHeight >= 0 && _softKeyHeight != keyHeight && mounted) {
      setState((){
        _softKeyHeight = keyHeight;
        var maxHeight = max(keyHeight, _softKeyMaxHeight);
        print("键盘高度是:$_softKeyHeight");
        if (_softKeyMaxHeight != maxHeight) {
          updateAnimate();
        }
        _softKeyMaxHeight = maxHeight;
        if (widget.onHeightChange != null) {
          widget.onHeightChange!(_softKeyHeight);
        }

      });
      /*_softKeyHeight = keyHeight;
      print("键盘高度是:$_softKeyHeight");*/
    }
  }

  @override
  didUpdateWidget(ChatBottomInputWidget old) {
    super.didUpdateWidget(old);
    if (widget.shouldTriggerChange != old.shouldTriggerChange) {
      streamSubscription.cancel();
      streamSubscription = widget.shouldTriggerChange.listen((_) => hideBottomLayout());
    }
  }

  @override
  dispose() {
    print('=======================dispose');
    super.dispose();
    streamSubscription.cancel();
    if(keyboardShowStream != null) {
      keyboardShowStream?.cancel();
    }
  }

  void hideBottomLayout() {
    controller.reverse();
    print('hideBottomLayout=========================');
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mCurrentType != KeyboardInputType.voice) {
        mCurrentType = KeyboardInputType.text2;
      }
      print('hideBottomLayout=========================1200 $mEmojiLayoutShow $mAddLayoutShow');
      mEmojiLayoutShow = false;
      mAddLayoutShow = false;
      setBottomItemCache();
      setState(() => {});
    });
  }

  @override
  void initState() {
    super.initState();
    streamSubscription =
        widget.shouldTriggerChange.listen((_) => hideBottomLayout());
     WidgetsBinding.instance.addObserver(this);
    mEditController.addListener(() {
      inputContentStreamController.add(mEditController.text);
      print('mEditController.addListener===============');
      setState((){

      });
    });

    // 初始化动画
    controller = AnimationController(
      duration: const Duration(milliseconds: 300,),
      vsync: this,
    );

    //匀减速
    addAnimate();

    mEditFocusNode.addListener((){
      print(mEditFocusNode.hasFocus);
      if(!mEditFocusNode.hasFocus) {
        mEditFocusTime = DateTime.now();
        if (mCurrentType != KeyboardInputType.extra && mCurrentType != KeyboardInputType.emoji) {
          controller.reverse();
        }
      } else {
        mCurrentType = KeyboardInputType.text;
        controller.forward();
      }
    });

    print('keyboardShowStream==========init');
    keyboardShowStream = eventBus.on().listen((event) {
      print('keyboardShowStream====$event');
      if (event == 'chat_bottom_show_keyboard') {
        showSoftKey();
      }
    });

  }

  Future requestPermission() async {
    // 申请权限

    /*Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
            [PermissionGroup.storage, PermissionGroup.microphone]);

    // 申请结果

    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission == PermissionStatus.granted) {
      //  Fluttertoast.showToast(msg: "权限申请通过");

    } else {
      //Fluttertoast.showToast(msg: "权限申请被拒绝");

    }*/
  }

  @override
  Widget build(BuildContext context) {
    requestPermission();

    return Container(
      // height: getBottomHeight() + (_mEditHeight + 20), //mEditFocusNode.hasFocus
      color: bottomBackgroundColor,
      // color: Colors.pinkAccent,
      // padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 0.5))
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _addMargin(buildLeftButton()),
                Expanded(child: buildInputButton()),
                _addMargin(buildEmojiButton()),
                _addMargin(buildRightButton()),
              ],
            ),
          ),
          _buildBottomContainer(child: _buildBottomItem()),
        ],
      ),
    );
  }

  double getBottomHeight() {
    if(mEditFocusNode.hasFocus) {
      return _softKeyMaxHeight;
    }/* else if(DateTime.now().millisecondsSinceEpoch - mEditFocusTime.millisecondsSinceEpoch < 300) {
      return _softKeyHeight;
    }*/

    switch(mCurrentType){
      case KeyboardInputType.extra:
      case KeyboardInputType.emoji:
        print(_softKeyMaxHeight);
        return _softKeyMaxHeight;
      default:
        return 0;
    }
  }

  Widget buildLeftButton() {
    return mCurrentType == KeyboardInputType.voice ? mKeyBoardButton() : mRecordButton();
  }

  Widget mRecordButton() {
    return ImageButton(
      onPressed: () {
        mCurrentType = KeyboardInputType.voice;
        hideSoftKey();
        mEmojiLayoutShow = false;
        mAddLayoutShow = false;
        controller.reverse();
        Future.delayed(const Duration(milliseconds: 300), () {
          setBottomItemCache();
        });
        setState(() {});
      },
      image: const AssetImage("${Constant.ASSETS_IMG}ic_audio.png"),
    );
  }

  Widget mKeyBoardButton() {
    return ImageButton(
      onPressed: () {
        mCurrentType = KeyboardInputType.text;
        showSoftKey();
        setState(() {});
      },
      image: const AssetImage("${Constant.ASSETS_IMG}ic_keyboard.png"),
    );
  }

  Widget mVoiceButton(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: RecordButton(onAudioCallBack: (value, duration) {
        widget.onAudioCallBack?.call(value, duration);
      }),
      // child: const Text('按住说话'),
    );
  }

  Widget buildInputButton() {
    final voiceButton = mVoiceButton(context);
    final inputButton = HeightReporter(
      child: Container(
        // height: 40,
        constraints: const BoxConstraints(
          maxHeight: 200.0,
          minHeight: 40.0,
        ),

        child: TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          //minLines: 1,
          style: const TextStyle(fontSize: 16),
          focusNode: mEditFocusNode,
          controller: mEditController,
          decoration: const InputDecoration(
            isDense: true,
            // filled: true,
            contentPadding:
            EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
        ),
      ),
      sizeChange: (height) {
        print('_mEditHeight==============$height');
        if (_mEditHeight != height) {
          setState((){
            _mEditHeight = height;
          });
        }
      },
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color(0xffFEFFFE),
      ),
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      child: Stack(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Offstage(
            offstage: mCurrentType != KeyboardInputType.voice,
            child: SizedBox(
              height: 40.0,
              child: voiceButton,
            ),
          ),
          Offstage(
            offstage: mCurrentType == KeyboardInputType.voice,
            child: Column(
              children: [
                inputButton,
                _buildQuoteItem(widget.currentMessage)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmojiButton() {
    return mCurrentType != KeyboardInputType.emoji ? mEmojiButton() : mEmojiKeyBoardButton();
  }

  Widget mEmojiButton() {
    return ImageButton(
      onPressed: () {
        mCurrentType = KeyboardInputType.emoji;
        setState(() {
          mEmojiLayoutShow = true;
          if (widget.onHeightChange != null) {
            widget.onHeightChange!(_softKeyMaxHeight);
          }
        });
        controller.forward();
        hideSoftKey();
      },
      image: const AssetImage("${Constant.ASSETS_IMG}ic_emoji.png"),
    );
  }

  Widget mEmojiKeyBoardButton() {
    return ImageButton(
      onPressed: () {
        mCurrentType = KeyboardInputType.text2;
        mEmojiLayoutShow = false;
        setState(() {});
        showSoftKey();
      },
      image: const AssetImage("${Constant.ASSETS_IMG}ic_keyboard.png"),
    );
  }

  Widget buildRightButton() {
    return mCurrentType != KeyboardInputType.extra ? mRightButton() : mRightKeyBoardButton();
  }

  Widget mRightKeyBoardButton() {
    return ImageButton(
      onPressed: () {
        mCurrentType = KeyboardInputType.text2;
        mEmojiLayoutShow = false;
        mAddLayoutShow = false;
        setState(() {});
        showSoftKey();
        controller.forward();
      },
      image: const AssetImage("${Constant.ASSETS_IMG}ic_keyboard.png"),
    );
  }

  Widget mRightButton() {
    return StreamBuilder<String>(
      stream: inputContentStream,
      builder: (context, snapshot) {
        final sendButton = buildSend();
        final extraButton = ImageButton(
            image: const AssetImage("${Constant.ASSETS_IMG}ic_add.png"),
            onPressed: () {
              mCurrentType = KeyboardInputType.extra;
              mEmojiLayoutShow = false;
              mAddLayoutShow = true;
              if (widget.onHeightChange != null) {
                widget.onHeightChange!(_softKeyMaxHeight);
              }
              hideSoftKey();
              controller.forward();
              setState(() {});
            });
        CrossFadeState crossFadeState =
            checkShowSendButton(mEditController.text)
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond;
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 0),
          crossFadeState: crossFadeState,
          firstChild: sendButton,
          secondChild: extraButton,
        );
      },
    );
  }

  Widget buildSend() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: 60,
      height: 30,
      child: ElevatedButton(
        onPressed: () {
          // 发送消息
          widget.onSendCallBack?.call(mEditController.text.trim());
          mEditController.clear();
        },
        child: const Text(
          "发送",
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }

  bool checkShowSendButton(String text) {
    if (mCurrentType == KeyboardInputType.voice) {
      return false;
    }
    if (text.trim().isNotEmpty) {
      return true;
    }
    return false;
  }

  void showSoftKey() {
    FocusScope.of(context).requestFocus(mEditFocusNode);
  }

  void hideSoftKey() {
    mEditFocusNode.unfocus();

    //启动动画(反向执行)
    // controller.reverse();
  }

  Widget _addMargin(Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 6),
      // color: Colors.green,
      child: child,
    );
  }

  Widget _buildBottomContainer({required Widget child}) {
    return SizedBox(
      height: animation.value,
      child: SizedBox(
        key: globalKey,
        height: _softKeyMaxHeight,
        child: child,
      ),
    );
  }

  Widget _buildBottomItem() {
    Widget? bottomItem;
    if (mCurrentType == KeyboardInputType.extra) {
      bottomItem = Visibility(
        visible: mAddLayoutShow,
        child: ChatMorePage(
          onSelectedImageCallBack: (value) {
            widget.onSelectedImageCallBack?.call(value);
          },
          onSelectedFileCallBack: (value) {
            widget.onSelectedFileCallBack?.call(value);
          }
        ),
        /*child: DefaultExtraWidget(
          onImageSelectBack: (value) {
            widget.onSelectedImageCallBack?.call(value);
          }
        )*/
      );
    } else if (mCurrentType == KeyboardInputType.emoji) {
      bottomItem = SizedBox(
        child: EmojiWidget(onEmojiClockBack: (value) {
           if (0 == value) {
            mEditController.clear();
          } else {
            mEditController.text =
                mEditController.text + String.fromCharCode(value);
          }
        }),
      );
    }
    if(bottomItem != null) {
      print('_buildBottomItem default =======' + getBottomHeight().toString());
      return bottomItemCache = bottomItem;
    } else {
      return bottomItemCache;
    }
  }

  /// 引用消息
  Widget _buildQuoteItem(HrlMessage? message) {
    HrlMessage? quoteMessage = message?.quoteMessage;
    if (quoteMessage == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.only(top: 4, left: 6, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16)
        ),
        color: Colors.grey.shade300,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              getQuoteInputText(quoteMessage),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ThemeColors.mainGray,
                fontSize: 12
              ),
              maxLines: 2,
            ),
          ),
          InkWell(
            onTap: (){
              print('close');
              if(message != null){
                message.quoteMessage = null;
                setState((){

                });
              }
            },
            child: Container(
              height: 16,
              width: 16,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade500,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }

  getQuoteInputText(HrlMessage quoteMessage) {
    String prevText = '${quoteMessage.from?.nick ?? ''}：';
    if (quoteMessage.isText()) {
      return quoteMessage.isText() ? prevText + ((quoteMessage as HrlTextMessage).text ?? '') : '';
    }
    if (quoteMessage.isImage()) {
      return '$prevText[图片]';
    }
    if (quoteMessage.isVideo()) {
      return '$prevText[视频]';
    }
    if (quoteMessage.isVoice()) {
      return '$prevText[音频]';
    }
    if (quoteMessage.isFile()) {
      return '$prevText[文件]';
    }
  }

  setBottomItemCache(){
    bottomItemCache = Container();
  }

  setUpdateState(){
    setState(() => {});
  }

  addAnimate(){
    animation = Tween(begin: 0.0, end: _softKeyMaxHeight)
      .animate(CurvedAnimation(parent: controller, curve: Curves.ease))
      ..addListener(setUpdateState);
  }

  updateAnimate(){
    animation.removeListener(setUpdateState);
    addAnimate();
  }
}
