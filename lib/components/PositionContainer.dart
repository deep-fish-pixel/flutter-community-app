import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/constants/themes.dart';

class PositionContainer extends StatefulWidget {
  const PositionContainer({Key? key, required this.child, required this.getSize}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Widget child;

  final Function(Size size, double offsetX, double offsetY)? getSize;

  @override
  State<PositionContainer> createState() => _PositionContainerState();
}

class _PositionContainerState extends State<PositionContainer> {
  double dx = 0;
  double dy = 0;
  double height = 0;
  double width = 0;
  bool hasSetted = false;
  GlobalKey _globalKey = GlobalKey();

  void initState() {
    super.initState();

    // 在控件渲染完成后执行的回调
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _findRenderObject();
    });
  }

  _findRenderObject() {
    RenderObject? renderObject = _globalKey.currentContext?.findRenderObject();
    if(renderObject != null) {
      RenderBox renderBox = renderObject as RenderBox;
      // offset.dx , offset.dy 就是控件的左上角坐标
      var offset = renderBox.localToGlobal(Offset.zero);

      setState(() {
        dx = offset.dx + (renderBox.size.width / 2);
        dy = offset.dy + (renderBox.size.height / 2);
        height = renderBox.size.height;
        width = renderBox.size.width;
        hasSetted = true;
        widget.getSize!(renderBox.size, offset.dx, offset.dy);
        // print('dy=======$dy');
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
      // key 要绑定在该控件上
      key: _globalKey,
      child: widget.child,
    );
  }
}