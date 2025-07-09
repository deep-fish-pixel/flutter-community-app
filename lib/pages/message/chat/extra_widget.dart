import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/constant.dart';
import 'extra_item.dart';


typedef void OnImageSelect(XFile mImg);


class DefaultExtraWidget extends StatefulWidget {

  final OnImageSelect onImageSelectBack;

  const DefaultExtraWidget({
    Key? key,
    required this.onImageSelectBack,
  }) : super(key: key);




  @override
  _DefaultExtraWidgetState createState() => _DefaultExtraWidgetState();
}

class _DefaultExtraWidgetState extends State<DefaultExtraWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
         //mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 1,
            child: createPicitem(),
          ),
          Flexible(
            flex: 1,
            child: createVediotem(),
          ),
          Flexible(
            flex: 1,
            child: createFileitem(),
          ),
          Flexible(
            flex: 1,
            child: createLocationitem(),
          ),
         ],
      ),
    );
  }

  var imagePicker = ImagePicker();

  ExtraItemContainer createPicitem() => ExtraItemContainer(
        leadingIconPath: "${Constant.ASSETS_IMG}chat/ic_details_photo.webp",
        leadingHighLightIconPath: "${Constant.ASSETS_IMG}chat/ic_details_photo.webp",
        text: "相册",
        onTab: () {
          Future<XFile?> imageFile = imagePicker.pickImage(source: ImageSource.gallery);
          imageFile.then((result) {
             widget.onImageSelectBack.call(result!);
          });
        },
      );

  ExtraItemContainer createVediotem() => ExtraItemContainer(
        leadingIconPath: "${Constant.ASSETS_IMG}chat/ic_ctype_video.png",
        leadingHighLightIconPath:
            "${Constant.ASSETS_IMG}chat/ic_ctype_video_pre.png",
        text: "拍摄",
        onTab: () {
          print("添加");
        },
      );

  ExtraItemContainer createFileitem() => ExtraItemContainer(
        leadingIconPath: "${Constant.ASSETS_IMG}chat/ic_ctype_file.png",
        leadingHighLightIconPath: "${Constant.ASSETS_IMG}chat/ic_ctype_file_pre.png",
        text: "文件",
        onTab: () {
          print("添加");
        },
      );

  ExtraItemContainer createLocationitem() => ExtraItemContainer(
        leadingIconPath: "${Constant.ASSETS_IMG}chat/ic_ctype_location.png",
        leadingHighLightIconPath: "${Constant.ASSETS_IMG}chat/ic_ctype_loaction_pre.png",
        text: "位置",
        onTab: () {
          print("添加");
        },
      );
}
