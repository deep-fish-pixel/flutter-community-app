import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:image_editor_plus/image_editor_plus.dart';



String getEditUrl(url){
  return url.replaceFirstMapped(RegExp(r'(_edit)?(.\w+)$'), (match) {
    return '_edit${match.group(2) ?? match.group(1)}';
  });
}


class SudokuImagesEditor extends StatefulWidget {
  final List<String> urls;
  final int position;
  final bool isEdit;
  Function(List<String> urls)? onImagesEdited;

  SudokuImagesEditor({
    Key? key,
    required this.urls,
    required this.position,
    this.onImagesEdited,
    this.isEdit = false
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SudokuImagesEditorViewState();
  }


}

class _SudokuImagesEditorViewState extends State<SudokuImagesEditor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    var urls = completeUrls(widget.urls.map((e) => e).toList());

    print('buildurls=================' + urls.toString());
    if(urls.length > 0){
      return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Column(
          children: getRows(urls, width),
        ),
      );
    }
    return Container();
  }

  List<Widget> getRows(List<String> urls, double width) {
    List<Widget> rows = [];
    if(urls.isNotEmpty) {
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
        var asset;
        if (urls[index] == '+') {
          asset = GestureDetector(
            onTap: () async {
              // Navigator.push(context, BottomPageRoute(widget, InformationCreatePage()));
              var result = await RouteUtil.push(context, RoutePath.informationCreatePage, params: {'editPage': true});
              if (result != null && result['filepath'] != null) {
                widget.urls.add(result['filepath']);
                print('image add=================== $result');
                setState(() {
                });
              }
            },
            child: DottedBorder(
              dashPattern: [8, 4],
              strokeWidth: 2,
              color: ThemeColors.mainGray99,
              padding: EdgeInsets.all(0),
              child: Container(
                height: imageHeight,
                width: double.infinity,
                child: const Icon(
                  Icons.add,
                  size: 40,
                  color: ThemeColors.mainGray99,
                )
              ),
            ),
          );
        } else if(urls[index] == ''){
          asset = Container();
        } else {
          asset = Container(
            height: imageHeight,
            width: double.infinity,
            child: GestureDetector(
              child: Image.file(
                File(urls[index]),
                fit: BoxFit.cover,
                height: imageHeight,
              ),
              onTap: () async {
                var editedImage = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageEditor(
                      image: File(urls[index]).readAsBytesSync(),
                    ),
                  ),
                );

                // replace with edited image
                if (editedImage != null) {
                  String editFilepath = getEditUrl(urls[index]);
                  await File(editFilepath).writeAsBytes(editedImage);
                  urls[index] = editFilepath;
                  if(widget.onImagesEdited != null){
                    widget.onImagesEdited!(urls.where((element) => element != '' && element != '+').toList());
                  }
                }
              },
            ),
          );
        }

        var image = Padding(
          // 分别指定四个方向的补白
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 4),
          child: ClipRRect( //剪裁为圆角矩形
            borderRadius: BorderRadius.circular(5.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                asset,
                Positioned(
                  top: 0,
                  right: 0,
                  child: urls[index] == '+' || urls[index] == ''? Container() : GestureDetector(
                    child: Container(
                      width: 30,
                      height: 30,
                      color: const Color.fromRGBO(51, 51, 51, 0.5),
                      child: const Icon(
                        Icons.close_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      print('image close $index');
                      urls.removeAt(index);
                      print('image close ${widget.urls.length}');
                      if(widget.onImagesEdited != null){
                        widget.onImagesEdited!(urls.where((element) => element != '' && element != '+').toList());
                      }
                      // widget.onRemove(index);
                    },
                  ),
                ),

              ],
            )
          ),
        );

        if(index == urls.length - 1 && urls.length % 3 > 0) {
          if(urls.length % 3 == 1){
            items.add(Expanded(
                flex: urls.length < 3 ? 3 : 1,
                child: image
            ));
            items.add(const Expanded(
                flex: 1,
                child: Text('')
            ));
            items.add(const Expanded(
                flex: 1,
                child: Text('')
            ));
          } else if(urls.length % 3 == 2){
            items.add(Expanded(
                flex: urls.length < 3 ? 1 : 1,
                child: image
            ));
            if(urls.length > 3) {
              items.add(const Expanded(
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


  completeUrls(List<String> urls){
    urls.add('+');
    if (urls.length % 3 == 1) {
      urls.add('');
    }
    if (urls.length % 3 == 2) {
      urls.add('');
    }
    return urls;
  }


}

// video
// https://video.momocdn.com/feedvideo/53/E7/53E7C752-5534-0E1A-B62E-E3DFEB06140620210506.mp4
// https://video.momocdn.com/feedvideo/17/49/1749BE36-6497-B81C-89EE-3E5BA3544C3D20210505.mp4
// https://video.momocdn.com/feedvideo/C5/37/C53791AD-E163-7AC2-62B6-838FB171669620210624.mp4
// https://video.momocdn.com/feedvideo/68/B6/68B6657A-9ABC-84FE-73BC-CD42EEE1734920210625.mp4
// https://video.momocdn.com/feedvideo/09/33/09338DCA-1FE3-7015-0AF7-B7494E6869F420210627.mp4