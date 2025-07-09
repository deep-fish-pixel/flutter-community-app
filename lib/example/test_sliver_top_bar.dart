import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Tab_indicator_styler.dart';

/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/11/2.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
///

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BannerHomepage(),
    );
  }
}

class BannerHomepage extends StatefulWidget {
  final bool isTitle;


  BannerHomepage({this.isTitle=true});

  @override
  State<StatefulWidget> createState() {
    return _BannerHomepageState();
  }
}

class _BannerHomepageState extends State<BannerHomepage> with TickerProviderStateMixin {
  double extraPicHeight = 0;//初始化要加载到图片上的高度
  late BoxFit fitType;//图片填充类型（刚开始滑动时是以宽度填充，拉开之后以高度填充）
  late double prevDy = 0;//前一次手指所在处的y值'
  late AnimationController animationController;
  late Animation<double> anim;

  @override
  void initState() {
    super.initState();
    prevDy = 0;
    fitType = BoxFit.fitWidth;

    animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    anim = Tween(begin: 0.0, end: 0.0).animate(animationController);
  }

  @override
  void dispose() {
    super.dispose();
  }

  updatePicHeight(changed){
    if(prevDy == 0){//如果是手指第一次点下时，我们不希望图片大小就直接发生变化，所以进行一个判定。
      prevDy = changed/5;
    }
    if(extraPicHeight >= 45){//当我们加载到图片上的高度大于某个值的时候，改变图片的填充方式，让它由以宽度填充变为以高度填充，从而实现了图片视角上的放大。
      fitType = BoxFit.fitHeight;
    }
    else{
      fitType = BoxFit.fitWidth;
    }
    extraPicHeight += changed/5 - prevDy;//新的一个y值减去前一次的y值然后累加，作为加载到图片上的高度。
    /*if (extraPicHeight > 100) {
      extraPicHeight = 100;
    }*/
    setState(() {//更新数据
      prevDy = changed/5;
      extraPicHeight = extraPicHeight;
      fitType = fitType;
    });
  }

  runAnimate(){//设置动画让extraPicHeight的值从当前的值渐渐回到 0
    setState(() {
      anim = Tween(begin: extraPicHeight, end: 0.0).animate(animationController)
        ..addListener((){
          if(extraPicHeight>=45){//同样改变图片填充类型
            fitType = BoxFit.fitHeight;
          }
          else{
            fitType = BoxFit.fitWidth;
          }
          setState(() {
            extraPicHeight = anim.value;
            fitType = fitType;
          });
        });
      prevDy = 0;//同样归零
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Listener(
          onPointerMove: (result) {//手指的移动时
            updatePicHeight(result.position.dy);//自定义方法，图片的放大由它完成。
          },
          onPointerUp: (_) {//当手指抬起离开屏幕时
            runAnimate();//动画执行
            animationController.forward(from: 0);//重置动画
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                leading: IconButton(//标题左侧的控件（一般是返回上一个页面的箭头）
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                floating: false,
                pinned: true,
                snap: false,
                //pinned代表是否会在顶部保留AppBar
                //floating代表是否会发生下拉立即出现SliverAppBar
                //snap必须与floating:true联合使用，表示显示SliverAppBar之后，如果没有完全拉伸，是否会完全神展开
                expandedHeight: 236 + extraPicHeight,//顶部控件所占的高度,跟随因手指滑动所产生的位置变化而变化。
                flexibleSpace: FlexibleSpaceBar(
                    title: null,
                    collapseMode: CollapseMode.pin,
                    background: SliverTopBar(
                      extraPicHeight: extraPicHeight,
                      fitType: fitType,
                    )//自定义Widget
                ),
              ),
              SliverList(//列表
                  delegate: SliverChildBuilderDelegate((context,i){
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: Text("This is item $i",
                        style: TextStyle(fontSize: 20),),
                      color: Colors.white70,);
                  },))
            ],
          ),
        )
    );
  }
}


class SliverTopBar extends StatelessWidget{
  const SliverTopBar({Key? key, required this.extraPicHeight, required this.fitType}) : super(key: key);
  final double extraPicHeight;//传入的加载到图片上的高度
  final BoxFit fitType;//传入的填充方式

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(//缩放的图片
              width: MediaQuery.of(context).size.width,
              /*child: NetworkImage(
                  'https://th.bing.com/th/id/OIP.lRLLKdA28DGKTuiEAsl_EAHaEK?pid=ImgDet&rs=1',
                  height: 180 + extraPicHeight,fit: fitType
              ),*/
              child: Image.network("https://th.bing.com/th/id/OIP.lRLLKdA28DGKTuiEAsl_EAHaEK?pid=ImgDet&rs=1",
                  height: 180 + extraPicHeight,fit: fitType),
            ),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 16,top: 10),
                    child: Text("QQ：54063222"),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16,top: 8),
                    child: Text("男：四川 成都"),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 30,
          top: 130 + extraPicHeight,
          child: Container(
            width: 100,
            height: 100,
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.lRLLKdA28DGKTuiEAsl_EAHaEK?pid=ImgDet&rs=1'),
            ),
          ),

        )
      ],

    );
  }

}

