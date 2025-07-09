class UserModel {
  String id = '';
  String nick = '';
  String headPic = '';

  UserModel({
    required this.id,
    required this.nick,
    required this.headPic
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nick = json['nick'];
    headPic = json['headPic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nick'] = this.nick;
    data['headPic'] = this.headPic;
    return data;
  }
}

List<UserModel> userModelListData = [UserModel(
    id: '1',
    nick: '人民日报',
    headPic: ''
), UserModel(
    id: '2',
    nick: '刘晓就',
    headPic: ''
), UserModel(
    id: '3',
    nick: '人生2024',
    headPic: ''
), UserModel(
    id: '4',
    nick: '开心平台账号',
    headPic: ''
), UserModel(
    id: '5',
    nick: '55555',
    headPic: ''
), UserModel(
    id: '6',
    nick: '66666',
    headPic: ''
), UserModel(
    id: '7',
    nick: '77777',
    headPic: ''
), UserModel(
    id: '8',
    nick: '88888',
    headPic: ''
), UserModel(
    id: '9',
    nick: '99999',
    headPic: ''
), UserModel(
    id: '10',
    nick: '1010101010',
    headPic: ''
), UserModel(
    id: '11',
    nick: '1111111111',
    headPic: ''
), UserModel(
    id: '12',
    nick: '121212121212',
    headPic: ''
), ];

// video
/*1
https://img.momocdn.com/feedvideo/52/EB/52EB14BD-415C-B0FF-A841-7E91B074029F20220818_L.jpg
https://video.momocdn.com/feedvideo/74/2B/742BEF3B-D0C6-DDFE-03FE-9C4C75E863B520220818.mp4
*/


/*
https://img.momocdn.com/feedvideo/D2/B9/D2B97E3A-9A18-022F-FE0C-43150374E46D20210506_L.jpg
https://video.momocdn.com/feedvideo/17/49/1749BE36-6497-B81C-89EE-3E5BA3544C3D20210505.mp4
* */