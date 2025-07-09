import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/routes/index.dart';

import '../../../constants/constant.dart';
import '/routes/generate_route.dart';

class MessagePage extends StatefulWidget {
  final bool isTransmit;
  final void Function(String chatId)? onSelected;
  const MessagePage({
    Key? key,
    this.isTransmit = false,
    this.onSelected
  }) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}


class _MessagePageState extends State<MessagePage> {
  selected(String chatId, {
    String name = '',
    bool activity = false
}){
    var onSelected = widget.onSelected;
    if (onSelected != null) {
      onSelected(chatId);
    } else {
      RouteUtil.push(context, RoutePath.chatPage, params: {
        'id': chatId,
        'name': name,
        'activity': activity,
      }, animate: RouteAnimate.swipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        widget.isTransmit ? SliverToBoxAdapter(child: Container(),) : SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                selected('123', name: '');
              },
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15, top: 2),
                      child: Image.asset(
                        'assets/images/message_at.webp',
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "@我的",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                                Spacer(),
                                Container(
                                  child: Image.asset(
                                    'assets/images/icon_right_arrow.png',
                                    width: 12.0,
                                    height: 15.0,
                                  ),
                                  margin: EdgeInsets.only(right: 20),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(top: 12),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 18),
                            height: 0.5,
                            color: Color(0xffE5E5E5),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
        widget.isTransmit ? SliverToBoxAdapter(child: Container(),) : SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '');
            },
            child: Container(
              //  margin: EdgeInsets.only( bottom: 10),

              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 2),
                    child: Image.asset(
                      'assets/images/message_comments.png',
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                "评论",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Spacer(),
                              Container(
                                child: Image.asset(
                                  'assets/images/icon_right_arrow.png',
                                  width: 12.0,
                                  height: 15.0,
                                ),
                                margin: EdgeInsets.only(right: 20),
                              )
                            ],
                          ),
                          margin: EdgeInsets.only(top: 12),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 18),
                          height: 0.5,
                          color: Color(0xffE5E5E5),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        widget.isTransmit ? SliverToBoxAdapter(child: Container(),) : SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              /*Routes.navigateTo(context, Routes.msgZanPage,
                    transition: TransitionType.fadeIn);*/
              RouteUtil.push(context, RoutePath.chatPage, animate: RouteAnimate.swipe);
            },
            child: Container(
              //  margin: EdgeInsets.only( bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 2),
                    child: Image.asset(
                      'assets/images/message_good.webp',
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                "赞",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Spacer(),
                              Container(
                                child: Image.asset(
                                  'assets/images/icon_right_arrow.png',
                                  width: 12.0,
                                  height: 15.0,
                                ),
                                margin: EdgeInsets.only(right: 20),
                              )
                            ],
                          ),
                          margin: EdgeInsets.only(top: 12),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 18),
                          height: 0.5,
                          color: Color(0xffE5E5E5),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        //消息布局
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              print('活动：一起跑步吧');
              selected('123', name: '活动：一起跑步吧', activity: true);
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "活动：一起跑步吧",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            const Spacer(),
                            Container(
                              margin: EdgeInsets.only(right: 15),
                              child: const Text(
                                "19:22",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "明天几点吃完饭?",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                width: 15,
                                height: 15,
                                decoration: new BoxDecoration(
                                  border: new Border.all(
                                      color: Colors.red, width: 0.5),
                                  // 边色与边宽度
                                  color: Colors.red,
                                  // 底色
                                  //        shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
                                  shape: BoxShape.circle, // 默认值也是矩形
                                  //    borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                                ),
                                child: Center(
                                  child: Text(
                                    "2",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '测试号002');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号002",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '测试号003');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号003",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '测试号004');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号004",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '测试号005');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号005",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '测试号006');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号006",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '测试号007');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号007",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '测试号008');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号008",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '测试号009');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号009",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '测试号010');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号010",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号002",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号002",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号002",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号002",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号002",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号002",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号002",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              selected('123', name: '');
            },
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "测试号002",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "10:26",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              margin: EdgeInsets.only(right: 15),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "可以啊,做的太好了",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}