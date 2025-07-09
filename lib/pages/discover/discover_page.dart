import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/blog/user_model.dart';
import 'package:gardener/provider/global_model.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:provider/provider.dart';

import '../../components/list_tile_view.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String communityName = '';

  @override
  initState() {
    super.initState();
    communityName = SharedUtil.getString(SPKeys.community) ?? '科技绿洲';
  }

  Widget buildContent(item) {
    return ListTileView(
      border: item['bottomMargin'] == true
          ? null
          : const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      title: item['label'],
      titleStyle: const TextStyle(fontSize: 15.0, color: ThemeColors.mainBlack),
      isLabel: false,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      icon: item['icon'],
      margin: EdgeInsets.only(
        top: item['topMargin'] == true ? 10.0 : 0.0,
        bottom: item['bottomMargin'] == true ? 10.0 : 0.0,
      ),
      onPressed: () {
        switch(item['label']){
          case '群广场':
            RouteUtil.push(context, RoutePath.groupSquarePage, animate: RouteAnimate.swipe, swipeEdge: true);
            break;
          case '活动广场':
            RouteUtil.push(context, RoutePath.activitySquarePage, animate: RouteAnimate.swipe, swipeEdge: true);
            break;
          case '社区服务':
            RouteUtil.push(context, RoutePath.communityServicePage, animate: RouteAnimate.swipe, swipeEdge: false);
            break;
        }

      },
      width: 25.0,
      fit: BoxFit.cover,
      horizontal: 15.0,
    );
  }

  Widget body() {
    List data = [
      {
        'label': '活动广场',
        'icon': const Icon(
          Icons.person,
          color: ThemeColors.mainBlack,
        ),
        'topMargin': true
      },
      // {'label': '直播 社区/周边周边'', 'icon': 'assets/images/mine/ic_pay.png', 'bottomMargin': true},
      {
        'label': '群广场',
        'icon': const Icon(
          Icons.person,
          color: ThemeColors.mainBlack,
        )
      },
      {
        'label': '社区服务',
        'icon': const Icon(
          Icons.person,
          color: ThemeColors.mainBlack,
        ),
        'bottomMargin': true
      },
      {
        'label': '游戏',
        'icon': const Icon(
          Icons.person,
          color: ThemeColors.mainBlack,
        ),
        'bottomMargin': true
      },
    ];

    return Column(
      children: <Widget>[
        Column(children: data.map(buildContent).toList()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(model.getCommunity()),
              ),
            ),
            Container(
              width: 68,
            )
          ]
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(child: body()),
    );
  }
}
