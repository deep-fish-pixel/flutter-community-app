import 'package:gardener/models/blog/user_model.dart';

class CommentModel {
  String content = '';
  late DateTime date;
  int supportNum = 0;
  List<CommentModel> childComments = [];
  late UserModel user;

  CommentModel({required this.user, required this.content, required this.date, required this.supportNum, required this.childComments});

  CommentModel.fromJson(Map<String, dynamic> json) {
    user = UserModel.fromJson(json['user']);
    content = json['content'];
    date = DateTime(json['date']);
    supportNum = json['supportNum'];
    childComments = json['childComments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['date'] = this.date;
    data['supportNum'] = this.supportNum;
    return data;
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