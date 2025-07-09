import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gardener/components/label_row.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/activity/activity_item_model.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/win_media.dart';

class ActivityInfo extends StatelessWidget {
  final bool dialog;
  final bool card;

  const ActivityInfo({
    Key? key,
    this.dialog = false,
    this.card = false,
  }): super(key: key);

  Widget getItem(ActivityItemModel itemModel){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 0),
          child: Text(itemModel.title,
            style: TextStyle(
                color: ThemeColors.mainGray,
                fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Text(itemModel.value,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ThemeColors.mainBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                itemModel.hasMap ? Container(
                  // color: Colors.red,
                  width: 20,
                  child: IconButton(
                    iconSize: 28,
                    padding: const EdgeInsets.all(2),
                    icon: Icon(RemixIcons.mapPinLine),
                    onPressed: () {  },
                  ),
                ) : Container()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getGrid(BuildContext context){
    double childAspectRatio = dialog ? 1.2 : 1.4;
    List<Widget> children = [];
    if (!dialog && !card) {
      children.add(
        getItem(ActivityItemModel(
          title: '活动名称',
          value: '笑嘻嘻活动',
        ))
      );
    }
    children.add(
      getItem(ActivityItemModel(
        title: '活动地点',
        value: '43栋活动室大转盘大转盘大转盘大转盘大转盘大转盘',
        hasMap: card ? false : true
      ))
    );
    if (!dialog && !card) {
      children.add(
        getItem(ActivityItemModel(
          title: '活动公告',
          value: '笑嘻嘻公告笑嘻嘻公告笑嘻嘻公告笑嘻嘻公告笑嘻嘻公告',
        ))
      );
    }

    if (card) {
      children.addAll([
        getItem(ActivityItemModel(
          title: '费用预计',
          value: '50￥/人',//无、不定
        )),
        getItem(ActivityItemModel(
          title: '活动时长',
          value: '2小时',
        )),
      ]);
    } else {
      children.addAll([
        getItem(ActivityItemModel(
          title: '费用预计',
          value: '50￥/人',//无、不定
        )),
        getItem(ActivityItemModel(
          title: '开始时间',
          value: '2023.01.01 16:00',
        )),
        getItem(ActivityItemModel(
          title: '活动时长',
          value: '2小时',
        )),

        getItem(ActivityItemModel(
          title: '年龄',
          value: '25-50岁',
        )),
        getItem(ActivityItemModel(
          title: '性别',
          value: '女',
        )),
        getItem(ActivityItemModel(
          title: '婚姻状况',
          value: '已婚',
        )),
        getItem(ActivityItemModel(
          title: '宝宝年龄',
          value: '3-5岁',
        )),
        getItem(ActivityItemModel(
          title: '可携带人数',
          value: '1人',
        )),
      ]);
    }



    return Container(
      color: Colors.white,
      height: (children.length / 3).ceil() * winWidth(context) / 3/ childAspectRatio,
      child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //横轴三个子widget
              childAspectRatio: childAspectRatio //宽高比为1时，子widget
          ),
          children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (!dialog && !card) {
      children.addAll([
        LabelRow(
          label: '活动状态',
          isRight: false,
          rightW: Text(
            '进行中/已结束/已终止',
            style: TextStyle(
              fontSize: 17.0,
              color: ThemeColors.mainGray,
            ),),
          onPressed: () => { },
        ),
        LabelRow(
          label: '活动评价',//进入评价详细列表
          isRight: true,
          rightW: Text(
            '4.3分',
            style: TextStyle(
              fontSize: 17.0,
              color: ThemeColors.mainGray,
            ),),
          onPressed: () => { },
        ),
        LabelRow(
          margin: const EdgeInsets.only(top: 10.0),
          label: '活动信息',
          isRight: true,
          rightW: Text(
            '设置',
            style: TextStyle(
              fontSize: 17.0,
              color: ThemeColors.mainGray,
            ),),
          onPressed: () => {
            RouteUtil.push(context, RoutePath.activityInfoSettingsPage)
          },
        ),
      ]);
    }
    children.add(getGrid(context));

    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: dialog ? 0 : 10),
      child: Column(
        children: children,
      ),
    );
  }
}
