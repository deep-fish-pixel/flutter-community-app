import 'package:flutter/material.dart';

import '../app_bar_header.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomSliverHeaderDemo(),
      routes: {
        'sliver_widgets': (context) => CustomSliverHeaderDemo()
      },
    );
  }
}
