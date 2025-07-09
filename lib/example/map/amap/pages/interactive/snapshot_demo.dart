import 'dart:typed_data';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import '../../base_page.dart';
import '../../const_config.dart';
import 'package:flutter/material.dart';

class SnapshotPage extends BasePage {
  SnapshotPage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _SnapShotBody();
  }
}

class _SnapShotBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SnapShotState();
}

class _SnapShotState extends State<_SnapShotBody> {
  late AMapController _mapController;
  late Uint8List _imageBytes;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: AMapWidget(
              apiKey: ConstConfig.amapApiKeys,
              onMapCreated: _onMapCreated,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
                child: Text('截屏'),
                onPressed: () async {
                  final imageBytes = await _mapController.takeSnapshot();
                  setState(() {
                    if(imageBytes != null) {
                      _imageBytes = imageBytes;
                    }
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.blueGrey[50]),
              child: _imageBytes != null ? Image.memory(_imageBytes) : null,
            ),
          ),
        ],
      ),
    );
  }

  _onMapCreated(AMapController controller) {
    _mapController = controller;
  }
}
