import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/components/cached_image.dart';
import 'package:gardener/components/easy_image_video_viewer/easy_image_viewer.dart';
import 'package:gardener/components/easy_image_video_viewer/src/easy_view_child.dart';
import 'package:gardener/components/video_page/video_page_builder.dart';
import 'package:gardener/constants/chat_constant.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/message/message_normal.dart';
import 'package:gardener/pages/message/chat/message_file.dart';
import 'package:gardener/pages/message/constant.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'bubble.dart';
import 'message_pop_menu.dart';
import 'message_video.dart';
import 'message_voice.dart';

class ChatMessageItem extends StatefulWidget {
  HrlMessage mMessage;
  ValueSetter<String> onTap;
  void Function(HrlMessage message) onQuoteSelected;
  bool isOnlyQuote;

  ChatMessageItem({
    Key? key,
    required this.mMessage,
    required this.onTap,
    required this.onQuoteSelected,
    this.isOnlyQuote = false,
  }) : super(key: key);

  @override
  ChatMessageItemState createState() => ChatMessageItemState();
}

class ChatMessageItemState extends State<ChatMessageItem> {
  bool mIsPlayint = false;
  String mUUid = "";


  methodInChild(bool isPlay, String uid) {
    mIsPlayint = isPlay;
    mUUid = uid;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOnlyQuote) {
      return getQuoteWidget(widget.mMessage);
    }
    return widget.mMessage.status < 0 ? Container() : Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: widget.mMessage.isSend == true
          ? getSentMessageLayout()
          : getReceivedMessageLayout(),
    );
  }

  Widget getmImageLayout(HrlImageMessage mMessgae) {
    Widget child;
    if (mMessgae.thumbPath != null && (!(mMessgae.thumbPath?.isEmpty == true))) {
      child =
          Image.file(File('${(widget.mMessage as HrlImageMessage).thumbPath}'));
    } else {
      child = Image.network(
        '${(widget.mMessage as HrlImageMessage).thumbUrl}',
        fit: BoxFit.fill,
      );
    }
    return child;
  }

  BubbleStyle getItemBundleStyle(HrlMessage mMessage) {
    BubbleStyle styleSendText = const BubbleStyle(
      nip: BubbleNip.rightText,
      color: Color(0xffCCEAFF),
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(left: 50.0),
      padding: BubbleEdges.only(top: 8, bottom: 10, left: 15, right: 10),
    );
    BubbleStyle styleSendImg = const BubbleStyle(
      nip: BubbleNip.noRight,
      color: Colors.transparent,
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(left: 50.0),
    );

    BubbleStyle styleReceiveText = const BubbleStyle(
      nip: BubbleNip.leftText,
      color: Colors.white,
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(right: 50.0),
      padding: BubbleEdges.only(top: 8, bottom: 10, left: 10, right: 15),
    );

    BubbleStyle styleReceiveImg = const BubbleStyle(
      nip: BubbleNip.noLeft,
      color: Colors.transparent,
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(left: 50.0),
    );

    switch (mMessage.msgType) {
      case HrlMessageType.image:
        return widget.mMessage.isSend == true ? styleSendImg : styleReceiveImg;
      case HrlMessageType.text:
        return widget.mMessage.isSend == true ? styleSendText : styleReceiveText;
      case HrlMessageType.voice:
        return widget.mMessage.isSend == true ? styleSendText : styleReceiveText;
      default:
        return styleSendText;
    }
  }

  Widget getSentMessageLayout() {
    return Container(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LimitedBox(
              maxWidth: getMaxWidth(widget.mMessage),
              child: showMessage(false),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 5),
              child: CircleAvatar(
                backgroundImage: CachedImage.getProvider("https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg"),
                radius: 16.0,
              ),
            ),
          ],
        ));
  }

  Widget getReceivedMessageLayout() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        //  mainAxisAlignment:MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 5.0, left: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg"),
              radius: 16.0,
            ),
          ),
          MessagePopMenu(
            type: widget.mMessage.msgType ?? HrlMessageType.text,
            message: widget.mMessage,
            onSelected: onPopMenuSelected,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: getMaxWidth(widget.mMessage),
              ),
              padding: const EdgeInsets.only(top: 4),
              child: showMessage(true),
            ),
          ),
        ],
      )
    );
  }



  double getMaxWidth(HrlMessage mMessage){
    double width = MediaQuery.of(context).size.width;
    switch(mMessage.msgType) {
      case HrlMessageType.image:
      case HrlMessageType.video:
      case HrlMessageType.voice:
        return width * 0.5;
      default:
        return width * 0.6;
    }
  }

  showMessage(bool isReceiver){
    var msgType = widget.mMessage.msgType;
    HrlMessage? quoteMessage = widget.mMessage.quoteMessage;
    switch(msgType){
      case HrlMessageType.text:
        return GestureDetector(
          onTap: () {
            print('========================onTap========================onTap');
            widget.onTap((widget.mMessage as HrlTextMessage).msgType ?? '');
          },
          child: ChatBubble(
            alignment: isReceiver ? Alignment.centerLeft : Alignment.centerRight,
            padding: isReceiver ? const EdgeInsets.only(top: 8, bottom: 8, left: 18, right: 12) : const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 18),
            backGroundColor: isReceiver ? Colors.white : Colors.pinkAccent,
            clipper: ChatBubbleClipper8(type: isReceiver ? BubbleType.receiverBubble : BubbleType.sendBubble, radius: ChatSize.radius),
            child: buildPopMenu(
              widget.mMessage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((widget.mMessage as HrlTextMessage).text ?? ''),
                  Container(
                    margin: quoteMessage != null ? const EdgeInsets.only(top: 4) : null,
                    // color: Colors.grey.shade300,
                    child: quoteMessage != null ? getQuoteWidget(quoteMessage) : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      case HrlMessageType.image:
      case HrlMessageType.video:
        HrlImageMessage message = widget.mMessage as HrlImageMessage;
        return ChatBubble(
          alignment: isReceiver ? Alignment.centerLeft : Alignment.centerRight,
          backGroundColor: isReceiver ? Colors.white : Colors.pinkAccent,
          padding: isReceiver ? const EdgeInsets.only(top: 0.5, bottom: 0.5, left: 7, right: 0.5) : const EdgeInsets.only(top: 0.5, bottom: 0.5, left: 0.5, right: 7),
          clipper: ChatBubbleClipper8(type: isReceiver ? BubbleType.receiverBubble : BubbleType.sendBubble),
          child: buildPopMenu(
            widget.mMessage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ChatSize.radius),
              child: buildImageMessage(message, false),
            ),
          ),
        );
      case HrlMessageType.voice:
        return ChatBubble(
            alignment: isReceiver ? Alignment.centerLeft : Alignment.centerRight,
            padding: isReceiver
                ? const EdgeInsets.only(top: 8, bottom: 8, left: 18, right: 12)
                : const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 18),
            backGroundColor: isReceiver
                ? Colors.white
                : /*Color(0xFF00A7FF)*/ Colors.pinkAccent,
            clipper: ChatBubbleClipper8(
                type: isReceiver
                    ? BubbleType.receiverBubble
                    : BubbleType.sendBubble,
                radius: ChatSize.radius),

            child: buildPopMenu(
              widget.mMessage,
              child: GestureDetector(
                onTap: () {
                  print('========================onTap========================onTap');
                  widget.onTap((widget.mMessage as HrlTextMessage).msgType ?? '');
                },
                child: buildVoiceMessage(widget.mMessage as HrlVoiceMessage)
              )
            ),
        );
      case HrlMessageType.file:
        return ChatBubble(
            alignment: isReceiver ? Alignment.centerLeft : Alignment.centerRight,
            padding: isReceiver
                ? const EdgeInsets.only(top: 8, bottom: 8, left: 18, right: 12)
                : const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 18),
            backGroundColor: isReceiver
                ? Colors.white
                : /*Color(0xFF00A7FF)*/ Colors.pinkAccent,
            clipper: ChatBubbleClipper8(
                type: isReceiver
                    ? BubbleType.receiverBubble
                    : BubbleType.sendBubble,
                radius: ChatSize.radius),
            child: buildPopMenu(
              widget.mMessage,
              child: GestureDetector(
                onTap: () {
                  print('========================onTap========================onTap');
                  widget.onTap((widget.mMessage as HrlTextMessage).msgType ?? '');
                },
                child: buildFileMessage(widget.mMessage as HrlFileMessage)
              )
            ),

        );
      default:
        return Container();
    }
  }

  buildPopMenu(HrlMessage mMessage, { child: Widget }){
    return MessagePopMenu(
        type: mMessage.msgType ?? HrlMessageType.text,
        message: mMessage,
        onSelected: onPopMenuSelected,
        child: child
    );
  }

  onPopMenuSelected(ItemModel item, HrlMessage message){
    print(item.value);
    if (item.value == MessageOperations.copy.value) {
      Clipboard.setData(ClipboardData(text: (message as HrlTextMessage).text));
      EasyLoading.showToast('复制成功');
    } else if (item.value == MessageOperations.delete.value) {
      message.status = HrlMessageStatus.delete;
      EasyLoading.showToast('删除成功');
      setState((){
      });
    } else if (item.value == MessageOperations.redo.value) {
      message.status = HrlMessageStatus.redo;
      EasyLoading.showToast('撤销成功');
      setState((){
      });
    } else if (item.value == MessageOperations.format_quote.value) {
      widget.onQuoteSelected(message);
    } else if (item.value == MessageOperations.forwarding.value) {
      RouteUtil.push(
        context,
        RoutePath.
        transmitMessagePage,
        params: message
      );
    }
  }

  getQuoteWidget(HrlMessage quoteMessage) {
    bool isOnlyQuote = widget.isOnlyQuote;
    String prevText = isOnlyQuote ? '' : (quoteMessage.from?.nick ?? '');
    if (quoteMessage.isText()) {
      return Text(
        quoteMessage.isText() ? prevText + ((quoteMessage as HrlTextMessage).text ?? '') : '',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: ThemeColors.mainGray,
            fontSize: 12
        ),
        maxLines: 2,
      );
    }
    Text prevTextWidget = Text(
      prevText,
      style: const TextStyle(
        color: ThemeColors.mainGray,
        fontSize: 12
      ),
    );
    if (quoteMessage.isImage() || quoteMessage.isVideo()) {
      return SizedBox(
        width: 80,
        child: Row(
          children: [
            prevTextWidget,
            SizedBox(
              width: isOnlyQuote ? 80 : 30,
              height: isOnlyQuote ? 80 : 30,
              child: buildImageMessage(quoteMessage, true),
            ),
          ],
        ),
      );
    }
    if (quoteMessage.isVoice()) {
      return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: buildVoiceMessage(quoteMessage as HrlVoiceMessage, isQuote: true, quoteNickName: isOnlyQuote ? '' : quoteMessage.from?.nick ?? ''),
      );
    }
    if (quoteMessage.isFile()) {
      return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: buildFileMessage(quoteMessage as HrlFileMessage, isQuote: true, quoteNickName: isOnlyQuote ? '' : quoteMessage.from?.nick ?? ''),
      );
    }
    return Container();
  }

  buildImageMessage(HrlMessage message, bool isQuote){
    final UniqueKey tag = UniqueKey();
    HrlImageMessage imageMessage = message as HrlImageMessage;
    String url = imageMessage.thumbUrl ?? '';

    return GestureDetector(
        onTap: () {
          widget.onTap(imageMessage.msgType ?? '');
          showImageViewerPager(
            context,
            children: [
              EasyViewerChild(
                  buildChild: (BuildContext context) => const CachedImage(
                    'https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg?v='/* + Random().nextInt(1000).toString()*/,
                  )
              ),
              EasyViewerChild(
                  buildChild: (BuildContext context) => const CachedImage(
                    'https://img.xiumi.us/xmi/ua/3wa69/i/65e1e8689e829901b04b1bfa5ba96a40-sz_139219.jpg?x-oss-process=style/xmwebp?v=',
                  )
              ),
              EasyViewerChild(
                  buildChild: (BuildContext context) => const CachedImage(
                    'https://img.xiumi.us/xmi/ua/3wa69/i/4cf7841f92d13a67c0f25738ba1d3266-sz_125868.jpg?x-oss-process=style/xmwebp?v=',
                  )
              ),
              EasyViewerChild(
                  buildChild: (BuildContext context) => const CachedImage(
                    'https://img.xiumi.us/xmi/ua/3wa69/i/f80f3fc92d07972d039c74b8475ea562-sz_193955.jpg?x-oss-process=style/xmwebp?v=',
                  )
              ),
              EasyViewerChild(
                buildChild: (BuildContext context) => const VideoPageBuilder(
                  url: 'https://video.momocdn.com/feedvideo/74/2B/742BEF3B-D0C6-DDFE-03FE-9C4C75E863B520220818.mp4',
                ),
              ),
              EasyViewerChild(
                buildChild: (BuildContext context) => const VideoPageBuilder(
                  url: 'https://video.momocdn.com/feedvideo/17/49/1749BE36-6497-B81C-89EE-3E5BA3544C3D20210505.mp4',
                  autoPlay: true,
                ),
              ),
            ],
            showIndex: imageMessage.assetEntity?.type == AssetType.video || RegExp(r'\.mp4$').stringMatch(url) != null ? 5 : 0,
            tag: tag,
            swipeDismissible: true,
            // backgroundColor: Colors.transparent,
          );
        },
        child: Container(
          child: message.assetEntity != null ?
          Image(
              image: AssetEntityImageProvider(message.assetEntity!),
              fit: BoxFit.cover
          ) :
          RegExp(r'\.mp4$').stringMatch(url) != null ?
          MessageVideo(
            thumbnailUrl: 'https://f7.baidu.com/it/u=1594818260,346309816&fm=222&app=108&size=f360,240',
            videoUrl: url,
            small: isQuote,
          ) :
          CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: 100.0,
          ),
        )
    );
  }

  buildVoiceMessage(HrlVoiceMessage message, {
    bool isQuote = false,
    String quoteNickName = ''
  }){
    return MessageVoice(
      path: message.path,
      duration: message.duration ?? 1,
      isSend: message.isSend == true,
      onTap: widget.onTap,
      isQuote: isQuote,
      quoteNickName: quoteNickName,
    );
  }

  buildFileMessage(HrlFileMessage message, {
    bool isQuote = false,
    String quoteNickName = ''
  }){
    return MessageFile(
      name: message.name,
      path: message.thumbPath ?? '',
      isSend: message.isSend == true,
      quoteNickName: quoteNickName,
      isQuote: isQuote,
      onTap: widget.onTap,
    );
  }
}


