import 'package:flutter/material.dart';

class SingleVideo extends StatefulWidget {
  final String video;
  final String previewPic;
  final bool horizontal;

  const SingleVideo({Key? key, required this.video, required this.previewPic, required this.horizontal}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SingleVideoViewState();
  }
}

class _SingleVideoViewState extends State<SingleVideo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    var video = widget.video;
    var previewPic = widget.previewPic;
    if(video.isNotEmpty && previewPic.isNotEmpty){
      return Container(
        alignment: Alignment.topLeft,
        child: renderVideo(video, previewPic, widget.horizontal, width),
      );
    }
    return Text('');
  }

  Stack renderVideo(String video, String previewPic, bool horizontal, double width) {
    var imageHeight = horizontal ? 380 : 250;

    return Stack(
      alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
      children: <Widget>[
        Padding(
          // 分别指定四个方向的补白
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: ClipRRect( //剪裁为圆角矩形
            borderRadius: BorderRadius.circular(5.0),
            child: Image(
                alignment: Alignment.center,
                fit: BoxFit.fill,
                height: imageHeight * width / 411,
                image: NetworkImage(previewPic)
            ),
          ),
        ),
        Positioned(
          child: GestureDetector(
            onTap: _onClick,//写入方法名称就可以了，但是是无参的
            child: Image.asset("assets/images/play_btn.png",
              width: 70.0,
            ),
          ),

        )
    ]);
  }

  /*Image.asset("assets/images/avatar.png",
  width: 100.0,
  )*/


  void _onClick() {
    print('_onClick');
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


