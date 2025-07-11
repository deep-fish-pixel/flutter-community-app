import '../../base_page.dart';
import '../../const_config.dart';
import '../../widgets/amap_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class PolygonDemoPage extends BasePage {
  PolygonDemoPage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Body> {

// Values when toggling Polygon color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  Map<String, Polygon> _polygons = <String, Polygon>{};
  late String selectedPolygonId;

  void _onMapCreated(AMapController controller) {}

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    final int polygonCount = _polygons.length;
    final double offset = polygonCount * 0.01;
    points.add(_createLatLng(39.835334 + offset, 116.3710069));
    points.add(_createLatLng(39.843082 + offset, 116.3709830));
    points.add(_createLatLng(39.845932 + offset, 116.3642213));
    points.add(_createLatLng(39.845924 + offset, 116.3595219));
    points.add(_createLatLng(39.841562 + offset, 116.345568));
    points.add(_createLatLng(39.835347 + offset, 116.34575));
    return points;
  }

  void _add() {
    final Polygon polygon = Polygon(
      strokeColor: colors[++colorsIndex % colors.length],
      fillColor: colors[++colorsIndex % colors.length],
      strokeWidth: 15,
      points: _createPoints(),
    );
    setState(() {
      selectedPolygonId = polygon.id;
      _polygons[polygon.id] = polygon;
    });
  }

  void _remove() {
    final Polygon? selectedPolygon = _polygons[selectedPolygonId];
    //有选中的Marker
    if (selectedPolygon != null) {
      setState(() {
        _polygons.remove(selectedPolygonId);
      });
    } else {
      print('无选中的Polygon，无法删除');
    }
  }

  void _changeStrokeWidth() {
    final Polygon? selectedPolygon = _polygons[selectedPolygonId];
    if (selectedPolygon != null) {
      double currentWidth = selectedPolygon.strokeWidth;
      if (currentWidth < 50) {
        currentWidth += 10;
      } else {
        currentWidth = 5;
      }
      //有选中的Marker
      if (selectedPolygon != null) {
        setState(() {
          _polygons[selectedPolygonId] =
              selectedPolygon.copyWith(strokeWidthParam: currentWidth);
        });
      } else {
        print('无选中的Polygon，无法修改宽度');
      }
    }

  }

  void _changeColors() {
    final Polygon? polygon = _polygons[selectedPolygonId];
    setState(() {
      if (polygon != null) {
        _polygons[selectedPolygonId] = polygon.copyWith(
          strokeColorParam: colors[++colorsIndex % colors.length],
          fillColorParam: colors[(colorsIndex + 1) % colors.length],
        );
      }
    });
  }

  Future<void> _toggleVisible(value) async {
    final Polygon? polygon = _polygons[selectedPolygonId];
    setState(() {
      if (polygon != null) {
        _polygons[selectedPolygonId] = polygon.copyWith(
          visibleParam: value,
        );
      }
    });
  }

  void _changePoints() {
    final Polygon? polygon = _polygons[selectedPolygonId];

    if (polygon != null) {
      List<LatLng> currentPoints = polygon.points;
      List<LatLng> newPoints = <LatLng>[];
      newPoints.addAll(currentPoints);
      newPoints.add(LatLng(39.828809, 116.360364));

      setState(() {
        _polygons[selectedPolygonId] = polygon.copyWith(
          pointsParam: newPoints,
        );
      });
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      privacyStatement: ConstConfig.amapPrivacyStatement,
      initialCameraPosition:
          CameraPosition(target: LatLng(39.828809, 116.360364), zoom: 13),
      onMapCreated: _onMapCreated,
      polygons: Set<Polygon>.of(_polygons.values),
    );
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('添加'),
                            onPressed: _add,
                          ),
                          ElevatedButton(
                            child: const Text('删除'),
                            onPressed:
                                (selectedPolygonId == null) ? null : _remove,
                          ),
                          ElevatedButton(
                            child: const Text('修改边框宽度'),
                            onPressed: (selectedPolygonId == null)
                                ? null
                                : _changeStrokeWidth,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('修改边框和填充色'),
                            onPressed: (selectedPolygonId == null)
                                ? null
                                : _changeColors,
                          ),
                          AMapSwitchButton(
                            label: Text('显示'),
                            onSwitchChanged: _toggleVisible,
                            defaultValue: true,
                          ),
                          ElevatedButton(
                            child: const Text('修改坐标'),
                            onPressed: (selectedPolygonId == null)
                                ? null
                                : _changePoints,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
