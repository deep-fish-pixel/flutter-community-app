import 'package:flutter/material.dart';

class AMapGradView extends StatefulWidget {
  ///子控件列表
  final List<Widget> childrenWidgets;

  ///一行的数量
  int crossAxisCount = 1;

  ///宽高比
  double childAspectRatio = 1;

  AMapGradView(
      {Key? key,
      this.crossAxisCount  = 1,
      this.childAspectRatio = 1,
      required this.childrenWidgets})
      : super(key: key);
  @override
  _GradViewState createState() => _GradViewState();
}

class _GradViewState extends State<AMapGradView> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        primary: false,
        physics: new NeverScrollableScrollPhysics(),
        //水平子Widget之间间距
        crossAxisSpacing: 1.0,
        //垂直子Widget之间间距
        mainAxisSpacing: 0.5,
        //一行的Widget数量
        crossAxisCount: widget.crossAxisCount,
        //宽高比
        childAspectRatio: widget.childAspectRatio,
        shrinkWrap: true,
        children: widget.childrenWidgets
    );
  }
}
