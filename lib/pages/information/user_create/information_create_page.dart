import 'dart:io';
import 'package:better_open_file/better_open_file.dart';
import 'package:flutter/material.dart';
import 'package:gardener/components/camerawesome/camerawesome_plugin.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:path_provider/path_provider.dart';


class InformationCreatePage extends StatefulWidget {
  const InformationCreatePage({Key? key}) : super(key: key);

  @override
  _CreateInformationPageState createState() => _CreateInformationPageState();
}

class _CreateInformationPageState extends State<InformationCreatePage> {
  @override
  void initState() {
    print('======================initState');
    super.initState();

    print('informationPageActiveNotifier.setActive===false======================');
    informationPageActiveNotifier.setActive(false);
  }

  @override
  Widget build(BuildContext context) {
    print('======================build');
    var params = RouteUtil.getParams(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photoAndVideo(
          photoPathBuilder: () => _path(CaptureMode.photo),
          videoPathBuilder: () => _path(CaptureMode.video),
          initialCaptureMode: CaptureMode.photo,
        ),
        filter: AwesomeFilter.None,
        flashMode: FlashMode.auto,
        aspectRatio: CameraAspectRatios.ratio_max_max,
        previewFit: CameraPreviewFit.fitWidth,
        onMediaTap: (mediaCapture) {
          // OpenFile.open(mediaCapture.filePath);
          // print('====${mediaCapture.filePath}');
        },
        onVideoCreated: (filepath) {
          print('onVideoCreated=============1' + filepath.toString());
          // OpenFile.open(filepath);
          RouteUtil.push(context, RoutePath.informationEditorPage, params: {
            'filepath': filepath
          });
        },
        onPhotoCreated: (filepath) {
          print('onPhotoCreated=============2' + filepath.toString());
          // OpenFile.open(filepath);
          if (params != null && params['editPage'] == true) {
            print('onPhotoCreated=============3===' + params['editPage'].toString());
            RouteUtil.pop(context, {
              'filepath': filepath
            });
          } else {
            RouteUtil.push(context, RoutePath.informationEditorPage, params: {
              'filepath': filepath
            });
          }
        },
      ),
    );
  }

  Future<String> _path(CaptureMode captureMode) async {
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
    await Directory('${extDir.path}/test').create(recursive: true);
    final String fileExtension =
    captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
    final String filePath =
        '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    return filePath;
  }


  deactivate(){
    super.deactivate();
    print('======================deactivate');

  }

  dispose(){
    super.dispose();
    print('======================dispose');

    print('informationPageActiveNotifier.setActive===true======================');
    informationPageActiveNotifier.setActive(true);

  }


}




