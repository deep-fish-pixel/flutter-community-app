import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import '../../base_page.dart';
import '../../const_config.dart';
import 'package:flutter/material.dart';

class PoiClickDemoPage extends BasePage {
  PoiClickDemoPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => _Body();
}

class _Body extends StatefulWidget {
  _Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late Widget _poiInfo;
  @override
  Widget build(BuildContext context) {
    final AMapWidget amap = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      touchPoiEnabled: true,
      onPoiTouched: _onPoiTouched,
    );
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: amap,
          ),
          Positioned(
            top: 40,
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Container(
              child: _poiInfo,
            ),
          )
        ],
      ),
    );
  }

  Widget showPoiInfo(AMapPoi poi) {
    return Container(
      alignment: Alignment.center,
      color: Color(0x8200CCFF),
      child: Text(
        '您点击了 ${poi.name}',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _onPoiTouched(AMapPoi poi) {
    setState(() {
      _poiInfo = showPoiInfo(poi);
    });
  }
}
