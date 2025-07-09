import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/components/file_asset_picker/file_asset_picker.dart';
import 'package:gardener/constants/themes.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'chat_bottom.dart';
import 'chat_more_item_card.dart';
import 'chat_more_tab_picker_builder.dart';

class InputMediaModel {
  String title;
  Image icon;
  String value;

  InputMediaModel(this.title, this.icon, this.value);
}

class MessageOperations {
  static InputMediaModel photo = InputMediaModel('相册', Image.asset('assets/images/chat/ic_details_photo.webp', fit: BoxFit.cover), '1');
  static InputMediaModel takePhoto = InputMediaModel('拍摄', Image.asset('assets/images/chat/ic_details_camera.webp', fit: BoxFit.cover), '2');
  static InputMediaModel localtion = InputMediaModel('位置', Image.asset('assets/images/chat/ic_details_localtion.webp', fit: BoxFit.cover), '4');
  static InputMediaModel file = InputMediaModel('文件', Image.asset('assets/images/chat/ic_details_file.webp', fit: BoxFit.cover), '5');
  static InputMediaModel telphone = InputMediaModel('语音通话', Image.asset('assets/images/chat/ic_details_media.webp', fit: BoxFit.cover), '6');
}


class ChatMorePage extends StatefulWidget {
  OnImageSelect? onSelectedImageCallBack;
  OnFileSelect? onSelectedFileCallBack;
  ChatMorePage({
    Key? key,
    this.onSelectedImageCallBack,
    this.onSelectedFileCallBack
  }) : super(key: key);

  @override
  _ChatMorePageState createState() => _ChatMorePageState();
}

class _ChatMorePageState extends State<ChatMorePage> {
  final List<File> fileList = <File>[];

  List<InputMediaModel> data = [
    MessageOperations.photo,
    MessageOperations.takePhoto,
    MessageOperations.file,
    MessageOperations.telphone,
    MessageOperations.localtion,
  ];

  final int maxAssets = 9;
  late final ThemeData theme = AssetPicker.themeData(ThemeColors.main);

  List<AssetEntity> entities = <AssetEntity>[];

  List<AssetEntity> assets = <AssetEntity>[];

  action(InputMediaModel model,) async {
    print(model.value);
    if (model.value == MessageOperations.photo.value) {
      pickPhoto(context);
    } else if (model.value == MessageOperations.takePhoto.value) {
      pickFromCamera(context);
    } else if (model.value == MessageOperations.file.value) {
      pickPhoto(context);
    } else {
      // showToast('敬请期待$name');
      EasyLoading.showToast('敬请期待${model.title}');
    }
  }

  Future<void> pickPhoto(BuildContext context) async {
    final PermissionState ps = await AssetPicker.permissionCheck();

    final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
        selectedAssets: entities,
        maxAssets: maxAssets,
        requestType: RequestType.common
    );
    final DefaultAssetPickerProvider imagesProvider =
    DefaultAssetPickerProvider(
      selectedAssets: entities,
      maxAssets: maxAssets,
    );
    final DefaultAssetPickerProvider videosProvider =
    DefaultAssetPickerProvider(
      selectedAssets: entities,
      maxAssets: maxAssets,
      requestType: RequestType.video,
    );
    final MultiTabAssetPickerBuilder builder = MultiTabAssetPickerBuilder(
      provider: provider,
      imagesProvider: imagesProvider,
      videosProvider: videosProvider,
      initialPermission: ps,
      pickerTheme: theme,
      locale: Localizations.maybeLocaleOf(context),
    );
    final List<AssetEntity>? result = await AssetPicker.pickAssetsWithDelegate(
      context,
      delegate: builder,
    );
    if (result != null && widget.onSelectedImageCallBack != null) {
      widget.onSelectedImageCallBack!(result);
    }
  }

  Future<void> pickFile(BuildContext context) async {
    final FileAssetPickerProvider provider = FileAssetPickerProvider(
      selectedAssets: fileList,
    );
    final FileAssetPickerBuilder builder = FileAssetPickerBuilder(
      provider: provider,
      locale: Localizations.maybeLocaleOf(context),
    );
    final List<File>? result = await AssetPicker.pickAssetsWithDelegate(
      context,
      delegate: builder,
    );
    if (result != null && widget.onSelectedFileCallBack != null) {
      widget.onSelectedFileCallBack!(result);
    }
  }

  Future<void> pickFromCamera(BuildContext context) async {
    final AssetEntity? result = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(enableRecording: true),
    );
    if (result != null) {
      widget.onSelectedImageCallBack!([result]);
      /*if (mounted) {
        setState(() {});
      }*/
    }
  }

  itemBuild(List<InputMediaModel> data) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        runSpacing: 10.0,
        spacing: 10,
        children: List.generate(data.length, (index) {
          return ChatMoreItemCard(
            model: data[index],
            onPressed: () => action(data[index]),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return itemBuild(data);
  }
}
