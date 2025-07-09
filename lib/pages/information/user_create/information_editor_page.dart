import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/components/list_tile_view.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/base/KeyValue.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/pages/information/user_create/components/showVisiblityModel.dart';
import 'package:gardener/pages/information/user_create/components/sudoku_images_editor.dart';
import 'package:gardener/pages/information/user_create/components/text_editor.dart';
import 'package:gardener/pages/information/user_create/components/video_editor.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/util/toast.dart';
import 'package:gardener/util/win_media.dart';


class InformationEditorPage extends StatefulWidget {
  const InformationEditorPage({Key? key}) : super(key: key);

  @override
  _InformationEditorPageState createState() => _InformationEditorPageState();
}

class _InformationEditorPageState extends State<InformationEditorPage> {
  FocusNode descFocusNode = FocusNode();
  List<KeyValue> visibilityItems = getVisibilityItems();
  late KeyValue selectedItem;
  String descContent = '';
  String communityName = '';
  List<String> images = [];
  final FocusNode _descFocusNode = FocusNode();

  @override
  void initState() {
    print('======================initState');
    super.initState();
    selectedItem = visibilityItems.first;
    communityName = SharedUtil.getString(SPKeys.community) ?? '科技绿洲三期';
  }

  @override
  Widget build(BuildContext context) {
    print('======================build');
    var params = RouteUtil.getParams(context);

    print('======================build' + params.toString());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            RouteUtil.pop(context);
          },
        ),
        leadingWidth: 24,
        title: Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            '返回编辑',
            style: TextStyle(
                color: ThemeColors.mainGray,
                fontSize: 14
            ),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          _descFocusNode.unfocus();
          // FocusScope.of(context).requestFocus(_descFocusNode);
        },
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        TextEditor(
                          focusNode: _descFocusNode,
                        ),
                        ...renderOtherAssetsContent(params),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ButtonMain(
                      margin: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                      text: '存草稿',
                      width: winWidth(context)/3,
                      height: 50,
                      fontSize: 18,
                      theme: ButtonMain.themeCancel,
                      onPressed: (text) {
                        Toast.show('保存成功', context);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ButtonMain(
                      margin: const EdgeInsets.only(right: 10, left: 0, top: 10, bottom: 10),
                      text: '发布',
                      width: winWidth(context)/2,
                      height: 50,
                      fontSize: 18,
                      theme: ButtonMain.themeConfirm,
                      onPressed: (text) {
                        Toast.show('发布成功', context);
                        RouteUtil.pop(context);
                        RouteUtil.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  renderMedia(String filepath) {
    if (filepath.contains(RegExp('\.(mp4)'))) {
      /*return SingleAutoPlayVideo(
        video: vedio.url,
        previewPic: vedio.preview,
        horizontal: vedio.horizontal,
        scrollController: widget.scrollController ?? _scrollController,
        tabIndex: widget.tabIndex,
        tabActiveNotifier: widget.tabActiveNotifier,
        informationPageActiveNotifier: widget.informationPageActiveNotifier
      );*/
      return VideoEditor(
        video: filepath,
      );
    } else if (filepath.contains(RegExp('\.(jpg|jpeg|png|gif)'))) {
      String editUrl = getEditUrl(filepath);
      if (!images.contains(filepath) && !images.contains(editUrl)) {
        images.add(filepath);
      }
      return SudokuImagesEditor(
        urls: images,
        position: 0,
        isEdit: true,
        onImagesEdited: (List<String> urls){
          setState(() {
            images = urls;
          });
        },
      );
    }
  }

  Widget renderListTileView(item) {
    return ListTileView(
      border: item['bottomMargin'] == true
          ? null
          : const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      title: item['label'],
      titleStyle: const TextStyle(fontSize: 15.0, color: ThemeColors.mainBlack),
      isLabel: false,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      icon: item['icon'],
      margin: EdgeInsets.only(
        top: item['topMargin'] == true ? 10.0 : 0.0,
        bottom: item['bottomMargin'] == true ? 10.0 : 0.0,
      ),
      onPressed: () async {
        switch(item['value']){
          case 'lock':
            showVisiblityModel(context, visibilityItems, (KeyValue item) => {
              setState(() {
                item.checked = true;
                selectedItem = item;
              })
            });
            break;
          case 'site':
            var result = await RouteUtil.push(context, RoutePath.selectCommunityPage, animate: RouteAnimate.cupertino);
            print('site====================' + (result ?? ''));
            if (result != null) {
              setState((){
                communityName = result;
              });
            }
            break;
        }

      },
      width: 25.0,
      fit: BoxFit.cover,
      horizontal: 15.0,
    );
  }




  deactivate(){
    super.deactivate();
    print('======================deactivate');

  }

  dispose(){
    super.dispose();
    print('======================dispose');
    _descFocusNode.dispose();

  }

  renderOtherAssetsContent(params) {

    return [
      Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
        child: params['filepath'] == null ? null : renderMedia(params['filepath']),
      ),
      renderListTileView({
        'label': communityName,
        'value': 'site',
        'icon': const Icon(
            RemixIcons.mapPin2Line
        ),
        'bottomMargin': true
      },),
      renderListTileView({
        'label': selectedItem.key,
        'value': 'lock',
        'icon': selectedItem.icon,
        'bottomMargin': true
      },)
    ];
  }


}




