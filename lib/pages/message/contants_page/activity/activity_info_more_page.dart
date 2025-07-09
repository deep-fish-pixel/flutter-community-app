import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/pop_up_menu.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/contants_page/common/index.dart';
import 'package:gardener/pages/message/contants_page/common/models.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';


class ActivityInfoPage extends StatefulWidget {
  const ActivityInfoPage({Key? key}) : super(key: key);

  @override
  _ConstractActivityPageState createState() => _ConstractActivityPageState();
}

class _ConstractActivityPageState extends State<ActivityInfoPage> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    ContactInfo params = RouteUtil.getParams(context);
    print(params);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              title: Text(
                '${params.name}详细信息',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              elevation: 0,
              centerTitle: true,
              actions: <Widget>[
              ],
            )),
      body: Container(
        child: Text('123123'),
      )
    );
  }

}
