import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/blog/user_model.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';

import '../../components/list_tile_view.dart';

class CommunityServicePage extends StatefulWidget {
  @override
  _CommunityServicePageState createState() => _CommunityServicePageState();
}

class _CommunityServicePageState extends State<CommunityServicePage> {
  String communityName = '';

  @override
  initState() {
    super.initState();
    communityName = SharedUtil.getString(SPKeys.community) ?? '科技绿洲';
  }

  Widget buildContent(item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        item['icon'],
        Text(item['label']),
      ],
    );
  }

  List<Widget> body(UserModel model) {
    List data = [
      {
        'label': '客服',
        'icon': Icon(
          Icons.person,
        ),
      },
      {
        'label': '物业',
        'icon': Icon(
          Icons.person,
        ),
      },
      /*{
        'label': '物业处理-占位',
        'icon': Icon(
          Icons.person,
        ),
      },*/
      /*{
        'label': '物业联系',
        'icon': Icon(
          Icons.person,
        ),
        'bottomMargin': true
      },*/
      {
        'label': '派出所',
        'icon': Icon(
          Icons.person,
        ),
        'bottomMargin': true
      },
      {
        'label': '居委会',
        'icon': Icon(
          Icons.person,
        ),
        'bottomMargin': true
      },
    ];

    return data.map(buildContent).toList();
  }

  @override
  Widget build(BuildContext context) {
    // final model = Provider.of<UserModel>(context);
    final model = UserModel(
      id: '123',
      nick: '123',
      headPic: ''
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('社区服务'),
      ),
      // body: SingleChildScrollView(child: body(model)),
      body: GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //横轴三个子widget
            childAspectRatio: 1 //宽高比为1时，子widget
        ),
        children: body(model),
      ),
    );
  }
}
