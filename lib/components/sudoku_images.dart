import 'package:flutter/material.dart';
import 'package:gardener/routes/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../pages/information/picture_article_page.dart';
import '../routes/generate_route.dart';

class SudokuImages extends StatefulWidget {
  final List<String> urls;
  final int position;
  final bool userPage;

  const SudokuImages({
    Key? key,
    required this.urls,
    required this.position,
    this.userPage = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SudokuImagesViewState();
  }
}

class _SudokuImagesViewState extends State<SudokuImages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    var urls = widget.urls;
    if(urls.length > 0){
      return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Column(
          children: getRows(urls, width),
        ),
      );
    }
    return Text('');
  }

  List<Widget> getRows(List<String> urls, double width) {
    List<Widget> rows = [];
    if(urls.length > 0) {
      List<Widget> items = [];
      urls.asMap().keys.forEach((index) {
        if(index % 3 == 0) {
          items = [];
          rows.add(Flex(
            direction: Axis.horizontal,
            children: items,
          ));
        }
        // 设置图片高度
        var imageHeight = width * 124 / 411;
        if(urls.length == 1){
          imageHeight = width * 210 / 411;
        } else if(urls.length == 2){
          imageHeight = width * 180 / 411;
        }
        var position = widget.position;
        var image = Padding(
          // 分别指定四个方向的补白
          padding: EdgeInsets.fromLTRB(0, 0, 4, 4),
          child: ClipRRect( //剪裁为圆角矩形
            borderRadius: BorderRadius.circular(5.0),
            child: GestureDetector(
              child: Hero(
                tag: '${position}_1_$index', //唯一标记，前后两个路由页Hero的tag必须相同
                child: Image(
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                    height: imageHeight,
                    image: NetworkImage(
                        urls[index]
                    )
                ),
              ),
              onTap: () {
                RouteUtil.push(
                    context,
                    RoutePath.mediaSlidePage,
                    params: {
                      'index': 0,
                      'images': 0,
                      'type': AssetType.image,
                      'onlyMain': widget.userPage,
                    },
                    // animate: RouteAnimate.swipe,
                    swipeEdge: false
                );
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PictureArticlePage(),
                    settings: RouteSettings(
                      arguments: "from fistView2222",
                    ),
                  ),
                );*/
              },
            )
          ),
        );

        if(index == urls.length - 1 && urls.length % 3 > 0) {
          if(urls.length % 3 == 1){
            items.add(Expanded(
                flex: urls.length < 3 ? 3 : 1,
                child: image
            ));
            items.add(Expanded(
                flex: 1,
                child: Text('')
            ));
            items.add(Expanded(
                flex: 1,
                child: Text('')
            ));
          } else if(urls.length % 3 == 2){
            items.add(Expanded(
                flex: urls.length < 3 ? 1 : 1,
                child: image
            ));
            if(urls.length > 3) {
              items.add(Expanded(
                  flex: 1,
                  child: Text('')
              ));
            }
          }
        } else {
          items.add(Expanded(
              flex: 1,
              child: image
          ));
        }

      });
    }
    return rows;
  }




}

// video
// https://video.momocdn.com/feedvideo/53/E7/53E7C752-5534-0E1A-B62E-E3DFEB06140620210506.mp4
// https://video.momocdn.com/feedvideo/17/49/1749BE36-6497-B81C-89EE-3E5BA3544C3D20210505.mp4
// https://video.momocdn.com/feedvideo/C5/37/C53791AD-E163-7AC2-62B6-838FB171669620210624.mp4
// https://video.momocdn.com/feedvideo/68/B6/68B6657A-9ABC-84FE-73BC-CD42EEE1734920210625.mp4
// https://video.momocdn.com/feedvideo/09/33/09338DCA-1FE3-7015-0AF7-B7494E6869F420210627.mp4