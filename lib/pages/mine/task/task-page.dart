import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/gardener_icons.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/pages/user_detail_page.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/style/physics.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/style/style.dart';


class TaskPage extends StatefulWidget {
  final bool canPop;
  final Function? onPop;
  final Function? onSwitch;

  TaskPage({
    Key? key,
    this.canPop: false,
    this.onPop,
    this.onSwitch,
  }) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  double _titleOpacity = 0;
  double opacitySwitch = 0.35;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _titleOpacity = max(0, min(1, _scrollController.offset / 150));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double headerOpacity = 1 - _titleOpacity;

    return Container(
      color: ThemeColors.mainGrayBackground,
      alignment: Alignment.topCenter,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          buildAppBar(context, headerOpacity),
          buildNoviceTasks(),
          buildDayNormalTasks(),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context, double headerOpacity){
    return SliverAppBar(
      leading: GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        onTap: () {
          print('onTap');
          Navigator.pop(context);
        },
      ),
      floating: false,
      pinned: true, // 滑动到顶端时会固定住
      backgroundColor: ThemeColors.main,
      expandedHeight: 200.0,
      titleSpacing: 0,
      title: Opacity(
          opacity: headerOpacity <= opacitySwitch ?  _titleOpacity : 0,
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 30.0,
                  padding: EdgeInsets.only(left: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '金币:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        '113333',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              '≈',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          )
                      ),
                      const Text(
                        '现金:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      const Text(
                        '11.33',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 6),
                width: 60,
                height: 22,
                child: ButtonMain(
                  onPressed: (String text) {
                    print('success!!!!!!');
                  },
                  theme: ButtonMain.themeLine,
                  text: '提现',
                  fontSize: 12,

                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: 20,
                height: 26,
              ),
            ],
          )
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        title: Opacity(
          opacity: max(headerOpacity > opacitySwitch ? headerOpacity : 0, 0),
          child: Container(
              height: 60,
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const Text(
                          '113333',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        const Text(
                          '金币',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    child: const Text(
                      '≈',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      child: Container(
                        width: 300,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  const Text(
                                    '11.33',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  const Text(
                                    '现金',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 4),
                                  alignment: Alignment.centerRight,
                                  width: 52,
                                  height: 20,
                                  child: ButtonMain(
                                      onPressed: (String text) {
                                        print('success!!!!!!');
                                      },
                                      theme: ButtonMain.themeLine,
                                      text: '提现',
                                      fontSize: 10
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: <Color>[
                Colors.red.shade300,
                ThemeColors.main,
              ],
            ),
          ),
          child: Container(),
        ),
      ),
      forceElevated: true,
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => UserDetailPage(),
              ));
            },
            child: Text(
              '规则',
              style: TextStyle(
                color: Colors.white,
              ),
            )
        ),
      ],
    );
  }

  Widget buildNoviceTasks(){
    var taskTitle = {
      'title': '新手任务',
      'tip': '每个任务只能做一次'
    };
    var taskList = [
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '金币大礼包',
        'subTitle': '新人福利',
        'operate': '去领取',
        'score': 10000,
        'onPressed': (){
          print('去邀请');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '关注3位新朋友',
        'subTitle': '完成进度1/3',
        'operate': '去关注',
        'score': 1500,
        'onPressed': (){
          print('去关注');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '点赞5次',
        'subTitle': '完成进度1/5',
        'operate': '去点赞',
        'score': 1500,
        'onPressed': (){
          print('去点赞');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '评论动态3次',
        'subTitle': '完成进度1/3',
        'score': 1500,
        'operate': '去评论',
        'onPressed': (){
          print('去评论');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '参加3次活动',
        'subTitle': '完成进度1/3',
        'score': 1500,
        'operate': '去参加',
        'onPressed': (){
          print('去参加');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '发起1次活动',
        'subTitle': '',
        'score': 2000,
        'operate': '去发起',
        'onPressed': (){
          print('去发起');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '发1次视频或图片动态',
        'subTitle': '完成进度0/1',
        'score': 2000,
        'operate': '发动态',
        'onPressed': (){
          print('发动态');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '完善资料',
        'subTitle': '',
        'score': 4000,
        'operate': '去完善',
        'onPressed': (){
          print('去完善');
        }
      }
    ];

    return buildTasks(taskTitle, taskList);
  }

  Widget buildDayNormalTasks(){
    var taskTitle = {
      'title': '日常任务',
      'tip': '未领取的金币会在当天24点过期'
    };
    var taskList = [
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '邀请1新朋友必得20元，最高200',
        'subTitle': '邀请1人，必得20元',
        'score': 200000,
        'operate': '去邀请',
        'onPressed': (){
          print('去邀请');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '金币大抽奖，iPhone免费拿',
        'subTitle': '超多丰厚好礼',
        'score': 0,
        'operate': '抽大奖',
        'onPressed': (){
          print('抽大奖');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '每日签到',
        'subTitle': '连续签到奖励翻倍',
        'score': 500,
        'operate': '去签到',
        'onPressed': (){
          print('发动态');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '点赞1次动态',
        'subTitle': '完成0/1',
        'score': 1000,
        'operate': '去点赞',
        'onPressed': (){
          print('去点赞');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '对动态发表1次评论',
        'subTitle': '完成0/1',
        'score': 1000,
        'operate': '去评论',
        'onPressed': (){
          print('去评论');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '参加1次活动',
        'subTitle': '参加一次奖励',
        'score': 2000,
        'operate': '去参加',
        'onPressed': (){
          print('去参加');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '发起1次活动',
        'subTitle': '发起一次奖励',
        'score': 4000,
        'operate': '去发起',
        'onPressed': (){
          print('去发起');
        }
      },
      {
        'icon': 'assets/images/mine/ic_pay.png',
        'title': '发一次视频或图片动态',
        'subTitle': '',
        'score': 1000,
        'operate': '发动态',
        'onPressed': (){
          print('发动态');
        }
      }
    ];

    return buildTasks(taskTitle, taskList, marginBottom: true);
  }


  Widget buildTasks(Map<String, String> taskTitle,
      List<Map<String, Object>> taskList, {bool marginBottom = false }){
    List<Widget> widgets = [
      buildTaskTitle(taskTitle)
    ];
    widgets.addAll(taskList.map(buildTaskList));

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: marginBottom ? 10 : 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        // padding: EdgeInsets.only(top: 10),
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Widget buildTaskTitle(taskTitle){
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                width: 0.2,
                color: ThemeColors.mainBlack
            )
        ),
      ),
      child: ListTile(
        title: Text(
          taskTitle['title'] as String,
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: Text(
          taskTitle['tip'] as String,
          style: TextStyle(
              color: ThemeColors.mainGray
          ),
        ),
        style: ListTileStyle.list,
      ),
    );
  }

  Widget buildTaskList(task){
    var isValid = (task['score'] ?? 0) > 0;
    return ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Icon(
              RemixIcons.riFilterFill
          ),
        ),
        title: Text(
          task['title'],
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              task['subTitle'],
              style: TextStyle(
                  fontSize: 12
              ),
            ),
            Text(
              isValid ? (' +' + ((task['score'] ?? '').toString() ) + '金币') : '',
              style: TextStyle(
                fontSize: 12,
                color: ThemeColors.main
              ),
            ),
          ],
        ),
        trailing: ButtonMain(
          onPressed: (String text) {
            task['onPressed']();
          },
          theme: ButtonMain.themeLine,
          text: task['operate'],
          fontSize: 12,
          fontWeight: FontWeight.w900
        )
    );
  }

  // 构建固定高度的SliverList，count为列表项属相
  Widget buildSliverList([int count = 5]) {
    return SliverFixedExtentList(
      itemExtent: 50.0,
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          //创建列表项
          return Container(
            alignment: Alignment.center,
            child: Text('$index'),
          );
        },
        childCount: count,
      ),
    );
  }

  // 构建 header
  Widget buildHeader(int i) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text("Headerrr $i"),
    );
  }
}
