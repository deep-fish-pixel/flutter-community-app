import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui show Image;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/util/event_bus.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:gardener/models/message/message_normal.dart';
import 'package:gardener/pages/message/constant.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'chat_bottom.dart';
import 'expanded_viewport.dart';
import 'package:uuid/uuid.dart';
import 'message_item.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController listScrollController = ScrollController();
  List<HrlMessage> mlistMessage = [];

  //https://stackoverflow.com/questions/50733840/trigger-a-function-from-a-widget-to-a-state-object/50739019#50739019
  final changeNotifier = StreamController.broadcast();
  AudioPlayer mAudioPlayer = AudioPlayer();
  bool isPalyingAudio = false;
  String mPalyingPosition = "";
  bool isShowLoading = false;
  bool isBottomLayoutShowing = false;
  // 键盘显示
  bool keyboardShow = false;
  // 引用消息
  HrlMessage currentMessage = HrlMessage();

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }

  getHistroryMessage(bool isReceived) {
    print("获取历史消息");
    List<HrlMessage> mHistroyListMessage = [];
    final HrlFileMessage mFileMessage = HrlFileMessage(name: '2022年年度考核说明说明说明说明说明说明说明说明说明说明说明说明.doc');
    mFileMessage.msgType = HrlMessageType.file;
    mFileMessage.isSend = !isReceived;
    mFileMessage.from = HrlUserInfo(
        username: '小丸子',
        nick: '小丸子',
        headUrl: '小丸子'
    );

    mHistroyListMessage.add(mFileMessage);
    final HrlTextMessage mMessage = HrlTextMessage();
    mMessage.text = "测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息";
    mMessage.msgType = HrlMessageType.text;
    mMessage.isSend = !isReceived;
    mMessage.from = HrlUserInfo(
        username: '小丸子',
        nick: '小丸子',
        headUrl: '小丸子'
    );
    mHistroyListMessage.add(mMessage);
    final HrlTextMessage mMessage2 = HrlTextMessage();
    mMessage2.text = "测试消息测试消息测试";
    mMessage2.msgType = HrlMessageType.text;
    mMessage2.isSend = !isReceived;
    mMessage2.from = HrlUserInfo(
        username: '小丸子',
        nick: '小丸子',
        headUrl: '小丸子'
    );
    mHistroyListMessage.add(mMessage2);
    final HrlImageMessage mMessageImg = HrlImageMessage();
    mMessageImg.msgType = HrlMessageType.image;
    mMessageImg.isSend = !isReceived;
    mMessageImg.thumbUrl = "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg";
    mMessageImg.from = HrlUserInfo(
        username: '小丸子',
        nick: '小丸子',
        headUrl: '小丸子'
    );
    mHistroyListMessage.add(mMessageImg);
    final HrlImageMessage mMessageVideo = HrlImageMessage();
    mMessageVideo.msgType = HrlMessageType.video;
    mMessageVideo.isSend = !isReceived;
    mMessageVideo.thumbUrl = "https://video.momocdn.com/feedvideo/74/2B/742BEF3B-D0C6-DDFE-03FE-9C4C75E863B520220818.mp4";
    mMessageVideo.from = HrlUserInfo(
        username: '小丸子',
        nick: '小丸子',
        headUrl: '小丸子'
    );
    mHistroyListMessage.add(mMessageVideo);
    mlistMessage.addAll(mHistroyListMessage);
    mlistMessage.addAll(mHistroyListMessage);
  }

  //文本消息
  sendTextMsg(String hello) {
    final HrlTextMessage mMessage = HrlTextMessage();
    mMessage.text = hello;
    mMessage.msgType = HrlMessageType.text;
    mMessage.isSend = true;
    mlistMessage.add(mMessage);
  }

  @override
  void initState() {
    super.initState();
    getHistroryMessage(false);
    getHistroryMessage(true);
    listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        isShowLoading = true;
        setState(() {});
        Future.delayed(Duration(seconds: 2), () {
          getHistroryMessage(false);
          getHistroryMessage(true);
          isShowLoading = false;
          setState(() {});
        });
      }
    });
  }

  changeNotify(BuildContext context){
    print('changeNotify===========$keyboardShow');
    if (keyboardShow) {
      FocusScope.of(context).requestFocus(FocusNode());
      changeNotifier.sink.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    var params = RouteUtil.getParams(context) ?? {};
    print('params=======$params');

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              params['name'] ?? '小丸子',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            elevation: 0,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_horiz_outlined),
                onPressed: () {
                  // ChatInfoPage
                  RouteUtil.push(context, RoutePath.chatInfoPage, params: params);
                },
              ),
            ],
          )),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffEEEEEE),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  //  点击顶部空白处触摸收起键盘
                  changeNotify(context);
                },
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: Scrollable(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: listScrollController,
                    axisDirection: AxisDirection.up,
                    viewportBuilder: (context, offset) {
                      return ExpandedViewport(
                        offset: offset,
                        axisDirection: AxisDirection.up,
                        slivers: <Widget>[
                          SliverExpanded(),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (c, i) {
                                final GlobalKey<ChatMessageItemState>
                                mMessageItemKey = GlobalKey();
                                mMessageItemKey.currentState
                                    ?.methodInChild(false, "");
                                ChatMessageItem mChatItem = ChatMessageItem(
                                  key: mMessageItemKey,
                                  mMessage: mlistMessage[i],
                                  onTap: (String str) {
                                    changeNotify(context);
                                  },
                                  onQuoteSelected: (HrlMessage message){
                                    currentMessage.quoteMessage = message;
                                    print('onQuoteSelected====');
                                    eventBus.fire('chat_bottom_show_keyboard');
                                    setState((){

                                    });
                                  },
                                );
                                return mChatItem;
                              },
                              childCount: mlistMessage.length,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: isShowLoading
                                ? Container(
                              margin: EdgeInsets.only(top: 5),
                              height: 50,
                              child: const Center(
                                child: SizedBox(
                                  width: 25.0,
                                  height: 25.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                            )
                                : Container(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            buildChartBottom(context)
          ],
        ),
      ),
    );
  }

  buildChartBottom(BuildContext context) {
    Widget widget = ChatBottomInputWidget(
      shouldTriggerChange: changeNotifier.stream,
      currentMessage: currentMessage,
      onSendCallBack: (value) {
        print("发送的文字:$value");
        final HrlTextMessage mMessage = HrlTextMessage();
        mMessage.uuid = const Uuid().v4();
        mMessage.text = value;
        mMessage.msgType = HrlMessageType.text;
        mMessage.isSend = true;
        mMessage.state = HrlMessageState.sending;
        mMessage.quoteMessage = currentMessage.quoteMessage;
        mMessage.from = HrlUserInfo(
            username: '小丸子',
            nick: '小丸子',
            headUrl: '小丸子'
        );
        currentMessage.quoteMessage = null;

        mlistMessage.insert(0, mMessage);
        listScrollController.animateTo(0.00,
            duration: const Duration(milliseconds: 1),
            curve: Curves.easeOut);
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          mMessage.state = HrlMessageState.send_succeed;
          setState(() {});
        });
      },
      onHeightChange: (height) {
        keyboardShow = height != 0;
        print('onHeightChange===========$keyboardShow $height');
      },
      onSelectedImageCallBack: (assetEntities) {
        if (assetEntities.isNotEmpty) {
          List<HrlImageMessage> messages = [];
          assetEntities.forEach((assetEntity) {
            assetEntity.file.then((result) {
              if (result != null) {
                final HrlImageMessage mMessage = HrlImageMessage();
                mMessage.uuid = const Uuid().v4();
                if (assetEntity.type == AssetType.image) {
                  mMessage.msgType = HrlMessageType.image;
                } else if (assetEntity.type == AssetType.video) {
                  mMessage.msgType = HrlMessageType.video;
                }

                print('result.path===================' + result.path.toString());
                // /storage/emulated/0/Movies/REC4386962722709848908.mp4

                mMessage.isSend = true;
                mMessage.thumbPath = result.path;
                mMessage.assetEntity = assetEntity;
                mMessage.state = HrlMessageState.sending;
                mMessage.quoteMessage = currentMessage.quoteMessage;
                currentMessage.quoteMessage = null;

                mlistMessage.insert(0, mMessage);
                listScrollController.animateTo(0.00,
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.easeOut);
                messages.add(mMessage);
              }
            });
          });
          setState(() {});
          Future.delayed(const Duration(seconds: 1), () {
            messages.forEach((message) {
              message.state = HrlMessageState.send_succeed;
            });
            setState(() {});
          });
        }
      },
      onSelectedFileCallBack: (files) {
        if (files.isNotEmpty) {
          List<HrlFileMessage> messages = [];
          files.forEach((file) {
            final HrlFileMessage mMessage = HrlFileMessage(name: Uri.decodeFull(file.uri.path.replaceFirstMapped(RegExp(r'.*\/'), (match) => '')));
            mMessage.uuid = const Uuid().v4();
            mMessage.isSend = true;
            mMessage.thumbPath = file.path;
            mMessage.msgType = HrlMessageType.file;
            mMessage.file = file;
            mMessage.state = HrlMessageState.sending;
            mMessage.quoteMessage = currentMessage.quoteMessage;
            currentMessage.quoteMessage = null;

            mlistMessage.insert(0, mMessage);
            listScrollController.animateTo(0.00,
                duration: const Duration(milliseconds: 1),
                curve: Curves.easeOut);
            messages.add(mMessage);
          });
          setState(() {});
          Future.delayed(const Duration(seconds: 1), () {
            messages.forEach((message) {
              message.state = HrlMessageState.send_succeed;
            });
            setState(() {});
          });
        }
      },
      onAudioCallBack: (value, duration) {
        final HrlVoiceMessage mMessage = HrlVoiceMessage(
            path: value.path
        );
        mMessage.uuid = const Uuid().v4();
        mMessage.msgType = HrlMessageType.voice;
        mMessage.isSend = true;
        mMessage.duration = duration;
        mMessage.state = HrlMessageState.sending;
        mMessage.from = HrlUserInfo(
            username: '小丸子',
            nick: '小丸子',
            headUrl: '小丸子'
        );
        mMessage.quoteMessage = currentMessage.quoteMessage;
        currentMessage.quoteMessage = null;

        mlistMessage.insert(0, mMessage);
        listScrollController.animateTo(0.00,
            duration: const Duration(milliseconds: 1),
            curve: Curves.easeOut);
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          mMessage.state = HrlMessageState.send_succeed;
          setState(() {});
        });
      }
    );
    return widget;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      // return super.buildViewportChrome(context, child, axisDirection);
      return child;
    }
  }
}
