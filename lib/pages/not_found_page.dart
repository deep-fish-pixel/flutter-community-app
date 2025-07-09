import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Not Found"),
      ),
      body: Column(children: <Widget>[
        Center(
          child: Text("404"),
        ),
        TextButton(
          child: Text("Go Home"),
          onPressed: () {
            //导航到新路由
            Navigator.pop(context);
          },
        ),
      ],)
    );
  }
}