import 'dart:io';

import 'package:gardener/pages/message/constant.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class HrlMessageStatus {
  static int delete = -1;
  static int redo = -2;
}
class HrlMessage {
  String? uuid;
  HrlMessageState? state;
  bool? isSend;
  HrlUserInfo? from;
  HrlUserInfo? target;
  int? createTime; // 发送消息时间
  String? msgType;
  AssetEntity? assetEntity;
  File? file;
  int status = 0;
  HrlMessage? quoteMessage;


  HrlMessage({
    this.uuid,
    HrlMessageState? state,
    this.isSend,
    this.from,
    this.target,
    this.createTime,
    this.msgType,
    this.assetEntity,
    this.file,
  });

  set delete(bool delete) {}


  Map toJson() {
    return {
      'uuid': uuid,
      'isSend': isSend,
      'from': from?.toJson(),
      'createTime': createTime,
      'target': target?.toJson(),
      'type': msgType.toString()
    };
  }

  HrlMessage.fromJson(Map<dynamic, dynamic> json)
      : uuid = json['uuid'],
        createTime = json['createTime'],
        isSend = json['isSend'],
        from = HrlUserInfo.fromJson(json['from']),
        target = HrlUserInfo.fromJson(json['target']),
        msgType = json['msgType'];

  static dynamic generateMessageFromJson(Map<dynamic, dynamic> json) {
    if (json == null) {
      return null;
    }

    String type = json['type'];
    switch (type) {
      case HrlMessageType.text:
        return HrlTextMessage.fromJson(json);
        break;
      case HrlMessageType.image:
        return HrlImageMessage.fromJson(json);
        break;
      case HrlMessageType.voice:
        return HrlVoiceMessage.fromJson(json);
        break;
    }
  }

  isText(){
    return msgType == HrlMessageType.text;
  }

  isVideo(){
    return msgType == HrlMessageType.video;
  }

  isImage(){
    return msgType == HrlMessageType.image;
  }

  isVoice(){
    return msgType == HrlMessageType.voice;
  }

  isFile(){
    return msgType == HrlMessageType.file;
  }
}

enum HrlMessageState {
  sending, // 正在发送中
  send_succeed, // 发送成功
  send_failed, // 发送失败
}

class HrlUserInfo {
  String? id;
  String username;
  String nick;
  String headUrl;

  HrlUserInfo({
    this.id,
    required this.username,
    required this.nick,
    required this.headUrl
  });

  Map toJson() {
    return {
      'id': id,
      'username': username,
      'nick': nick,
      'headurl': headUrl,
    };
  }

  HrlUserInfo.fromJson(Map<dynamic, dynamic> json)
      : username = json['username'],
        id = json['id'],
        headUrl = json['headurl'],
        nick = json['nick'];
}

class HrlImageMessage extends HrlMessage {
  String? thumbPath;
  String? thumbUrl;

  HrlImageMessage({this.thumbPath, this.thumbUrl }) : super();

  Map toJson() {
    var json = super.toJson();
    json['thumbPath'] = thumbPath;
    json['thumbUrl'] = thumbUrl;

    return json;
  }

  HrlImageMessage.fromJson(Map<dynamic, dynamic> json)
      : thumbPath = json['thumbPath'],

  super.fromJson(json);
}

class HrlTextMessage extends HrlMessage {
  String? text;


  HrlTextMessage({this.text });



  Map toJson() {
    var json = super.toJson();
    json['text'] = text;
    return json;
  }

  HrlTextMessage.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'],
        super.fromJson(json);
}

class HrlVoiceMessage extends HrlMessage {
  String path; // 语音文件路径,如果为空需要调用相应下载方法，注意这是本地路径，不能是 url
  String? remoteUrl;

  int? duration; // 语音时长，单位秒


  HrlVoiceMessage({
    required this.path
}): super();

  Map toJson() {
    var json = super.toJson();
    json['path'] = path;
    json['duration'] = duration;
    json['remoteUrl'] = remoteUrl;

    return json;
  }

  HrlVoiceMessage.fromJson(Map<dynamic, dynamic> json)
      : path = json['path'],
        duration = json['duration'],
        remoteUrl = json['remoteUrl'],

      super.fromJson(json);
}

class HrlFileMessage extends HrlMessage {
  String? thumbPath;
  String? thumbUrl;
  String name;

  HrlFileMessage({required this.name, this.thumbPath, this.thumbUrl }) : super();

  Map toJson() {
    var json = super.toJson();
    json['thumbPath'] = thumbPath;
    json['thumbUrl'] = thumbUrl;

    return json;
  }

  HrlFileMessage.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'], thumbPath = json['thumbPath'],
        super.fromJson(json);
}

getEnumFromString<T>(Iterable<T> values, String str) {
  return values.firstWhere((f) => f.toString().split('.').last == str);
}

String getStringFromEnum<T>(T) {
  if (T == null) {
    return '';
  }
  return T.toString().split('.').last;
}
