import 'package:flutter/cupertino.dart';

class HeightReporter extends StatelessWidget {
  final Widget child;
  double _height = 0;
  Function(double width) sizeChange;

  HeightReporter({
    Key? key,
    required this.child,
    required this.sizeChange,
  }) : super(key: key);


  double getHeight() {
    return _height;
  }


  @override
  Widget build(BuildContext context) {
    print("HeightReporterBuild");
    Widget tmp = GestureDetector(
      child: child,
      onTap: () {
        print('Height is ${context.size?.height}');
      },
    );

    Future.delayed(const Duration(milliseconds: -1)).then((e) {
      _height = context.size?.height ?? 0;
      debugPrint('Height is ${_height}');
      sizeChange(_height);
    });

    return tmp;
  }
}