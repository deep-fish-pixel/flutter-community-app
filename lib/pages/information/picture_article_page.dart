import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/models/blog/user_model.dart';
import 'package:gardener/routes/generate_route.dart';
import '../../../constants/gardener_icons.dart';


/*class PictureArticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments; //arguments
    return Scaffold(
      body: TextButton(
        onPressed: () {},
        child: Text(args.toString() + '||||1231231231',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    )
  }
}*/

import '../../../constants/themes.dart';
import '../../../models/blog/comment_model.dart';

const images = <String>[
  'https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/65e1e8689e829901b04b1bfa5ba96a40-sz_139219.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/4cf7841f92d13a67c0f25738ba1d3266-sz_125868.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/3553a9363cf990862c6f236559fc98ca-sz_195633.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/73414e98d6debe9f42526875cb8658cf-sz_224834.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_1050,w_1050,x_0,y_175/format,webp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/f80f3fc92d07972d039c74b8475ea562-sz_193955.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/69eb48fe55532c85934cdf24807fc3f8-sz_181952.jpg?x-oss-process=style/xmwebp',
  'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F0814%2F17c8e8c3c106b879aa9f4e9189601c3b.jpg&refer=http%3A%2F%2Ffile02.16sucai.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663541917&t=a9a98cdae0ef8d8c280fe105ac01f852'
];

class PictureArticlePage extends StatefulWidget {
  const PictureArticlePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PictureArticleState();
  }

  @override
  Widget build(BuildContext context) {
    //获取路由参数
    var args=ModalRoute.of(context)?.settings.arguments;
    print('===================111');
    print(args);
    return Text('123123123');
  }
}

class PictureArticleState extends State<PictureArticlePage> {
  var _comments = <CommentModel>[];
  bool editing = false;

  TextEditingController editingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    editingController.addListener((){
      print('control======: ${editingController.text}');
    });
    // 设置field默认值
    // editingController.text="hello world!";
    // 判断焦点
    focusNode.addListener((){
      print('focusNode======: ${focusNode.hasFocus}');
      if(focusNode.hasFocus){
        setState(() => {
          editing = true
        });
      } else {
        setState(() => {
          editing = false
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    print(ModalRoute.of(context));
    print(ModalRoute.of(context)!.settings);
    List arguments = RouteUtil.getParams(context);
    print(arguments);

    return Scaffold(
      appBar: AppBar(
          title: Opacity(
            opacity: 0.8,
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: 60,
                  alignment: Alignment.centerLeft,
                  child: Container(
                      width: 46,
                      height: 46,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(46),
                      ),
                      child: Image(
                        image: NetworkImage('https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp'),
                      )
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 30.0,
                    child: Text(
                      '1234',
                      style: TextStyle(
                          color: ThemeColors.main,
                          fontSize: 24,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: 60,
                  height: 26,
                  child: ButtonMain(
                    text: '关注',
                    theme: ButtonMain.themeLine,
                    onPressed: (text){ },
                  ),
                )
              ],
            )
          ),
          automaticallyImplyLeading: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ],
        ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Container(
                height: height - 130,
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    print("======================");
                    print(context);
                    // 返回一个 Sliver 数组给外部可滚动组件。
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: SizedBox(
                          child: Container(
                            height: 550,
                            width: width,
                            child: Swiper(
                              itemBuilder: (context, index) {
                                final image = images[index];
                                return Hero(
                                  tag: '${arguments[0]}_$index', //唯一标记，前后两个路由页Hero的tag必须相同
                                  child: Image(
                                      alignment: Alignment.center,
                                      image: NetworkImage(image)
                                  ),
                                );
                              },
                              indicatorLayout: PageIndicatorLayout.COLOR,
                              itemCount: images.length,
                              index: arguments != null ? arguments[1] : 0,
                              pagination: SwiperCustomPagination(
                                builder:(BuildContext context, SwiperPluginConfig config){
                                  return  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      child: DotSwiperPaginationBuilder(
                                        color: Colors.grey.shade300
                                      ).build(context, config),
                                    ),
                                  );
                                },
                              )
                            )
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(16.0),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('法式风法式婚纱照', style: TextStyle(fontSize: 18),),
                                Text('法式风法式婚纱照', style: TextStyle(fontSize: 18),),
                                Text('法式风法式婚纱照', style: TextStyle(fontSize: 18),),
                                Text('@物业 @业委会', style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue.shade700
                                )),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 40.0,
                                        child: Text(
                                          '编辑于 2021-10-18',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:Alignment.centerRight , //指定未定位或部分定位widget的对齐方式
                                      child: Container(
                                        width: 40,
                                        child: IconButton(onPressed: (){}, icon: const Icon(
                                          GardenerIcons.dislike,
                                          size: 30,
                                        ), color: Colors.grey,),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ), //构建一个 sliverList
                    ];
                  },
                  body: ListView.builder(
                    physics: const ClampingScrollPhysics(), //重要
                    itemCount: _comments.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= _comments.length) {
                        if (_comments.length < 200) {
                          _retrieveData();
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(strokeWidth: 2.0),
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(16.0),
                            child: const Text(
                              "没有更多了",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }
                      }
                      return ListTile(title: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 54,
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      width: 44,
                                      height: 44,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(44),
                                      ),
                                      child: Image(
                                        image: NetworkImage(_comments[index].user.headPic),
                                      )
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            verticalDirection: VerticalDirection.up,
                                            children: [
                                              Text(
                                                _comments[index].user.nick,
                                                style: TextStyle(
                                                    color: ThemeColors.main,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              (_comments[index].user.nick == '123' ? Container(
                                                margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                                child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      borderRadius: BorderRadius.circular(26.0), //3像素圆角
                                                    ),
                                                    child: Container(
                                                      height: 20.0,
                                                      width: 44,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                          "作者",
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500
                                                          )
                                                      ),
                                                    )
                                                ),
                                              ) : Text('')),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            '等级3',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            '有没有宅男，又皮痒了，来伤害我一下。看我不打死你......',
                                            style: TextStyle(
                                              color: Color(0xFF5D5E5E), //Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                Container(
                                    width: 40,
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 30,
                                            alignment: Alignment.topCenter,
                                            child: IconButton(
                                              icon: Icon(
                                                GardenerIcons.like,
                                                color: Colors.black54,
                                              ),
                                              onPressed: () {  },
                                            )
                                        ),
                                        Container(
                                          height: 20,
                                          alignment: Alignment.topCenter,
                                          child: const Text(
                                            '1',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                )
                              ],
                            ),

                          ]
                      ));;
                    },
                  ),
                ),
              ),
              renderBottomBar(context)
            ],
          ),
        ),
      ),
      // bottomNavigationBar: renderBottomBar(context)
    );
  }

  renderMedia(int index) {
    return Text(index.toString());
  }

  renderBottomBar(context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: Colors.grey.shade300),),
      ),
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: editing ? 10 : 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.0), //3像素圆角
                  border: Border.all(width: 3, color: Colors.grey.shade200),
                ),
                height: 35.0,
                // color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: renderTextField(context),
                  ),
                ),
              )
          ),
          editing ? Expanded(
            flex: 5,
            child: Container(
              height: 50.0,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: TextButton(
                      child: Text("@", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54
                      ),),
                      onPressed: () {
                        EasyLoading.showToast('显示 关注+好友+物业+业委会等账号');
                      },
                    ),
                    width: 60,
                  ),
                  Container(
                      height: 26.0,
                      child: ElevatedButton(
                        child: Text("发送"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(ThemeColors.main),                //背景颜色
                          foregroundColor: MaterialStateProperty.all(Colors.white),                //字体颜色
                          overlayColor: MaterialStateProperty.all(Color(0xffFF7F24)),                   // 高亮色
                          shadowColor: MaterialStateProperty.all( ThemeColors.main),                  //阴影颜色
                          elevation: MaterialStateProperty.all(0),                                     //阴影值
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),              //字体
                          side: MaterialStateProperty.all(const BorderSide(
                              width: 1,
                              color: Color(0x00C7C7C7)
                          )
                          ),//边框
                          shape: MaterialStateProperty.all(
                              const StadiumBorder(
                                  side: BorderSide(
                                    //设置 界面效果
                                    style: BorderStyle.solid,
                                    color: Color(0xffFF7F24),
                                  )
                              )
                          ),//圆角弧度
                        ),
                        onPressed: () {
                          EasyLoading.showToast('发送内容');
                        },
                      )
                  )
                ],
              ),
            ),
          ) : renderComments(context) ,
        ],
      ),
    );
  }

  renderTextField(context){
    return TextField(
      autofocus: false,
      controller: editingController,
      // 控制焦点事件
      focusNode: focusNode,
      maxLines: 1,
      // onChanged: (value) {
      //   print('onChanged ${value}');
      // },
      decoration: InputDecoration(
        isDense: true,
        icon: Icon(
          GardenerIcons.edit,
          size: 24,
          color: Colors.black87,
        ),
        contentPadding: EdgeInsets.only(
            left: -10, right: 4, top: 4, bottom: 6),
        border: InputBorder.none,
        fillColor: Colors.grey.shade200,
        filled: true,
        hintStyle: TextStyle(color: Color(0xffcccccc), fontSize: 14),
        hintText: "说点什么吧"),
    );
  }

  renderComments(context){
    return Expanded(
      flex: 3,
      child: Container(
        height: 50.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(GardenerIcons.transmit, size: 32),
                  Flexible(child: Text(
                    "6172",
                    style: TextStyle(fontSize: 12),
                  ))
                ],
              ),
              onPressed: () {
                EasyLoading.showToast('转发功能');
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.black87, fontSize: 18),
                ),
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.black87;
                }),
              ),
            ),
            TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(GardenerIcons.like, size: 32),
                  Flexible(child: Text(
                    "6172",
                    style: TextStyle(fontSize: 12),
                  ))
                ],
              ),
              onPressed: (){
                EasyLoading.showToast('喜欢');
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(color: Colors.black87, fontSize: 14),
                ),
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.black87;
                }),
              ),
            ),
            TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(GardenerIcons.mark, size: 32),
                  Flexible(child: Text(
                    "6172",
                    style: TextStyle(fontSize: 12),
                  ))
                ],
              ),
              onPressed: (){
                EasyLoading.showToast('收藏');
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(color: Colors.black87, fontSize: 14),
                ),
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.black87;
                }),
              ),
            ),
            TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(GardenerIcons.edit, size: 32),
                  Flexible(child: Text(
                    "6172",
                    style: TextStyle(fontSize: 12),
                  ))
                ],
              ),
              onPressed: (){
                EasyLoading.showToast('查看评论', duration: Duration(milliseconds: 300));
                // _scrollController.position.
                // _scrollController.position.pixels = 100;
                // _scrollController.jumpTo(300);
                _scrollController.animateTo(400, duration: Duration(milliseconds: 550), curve: Curves.ease);
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(color: Colors.black87, fontSize: 14),
                ),
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.black87;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retrieveData() {
    Future.delayed(const Duration(milliseconds: 300)).then((e) {
      const pics = [
        'https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp',
        'https://img.xiumi.us/xmi/ua/3wa69/i/73414e98d6debe9f42526875cb8658cf-sz_224834.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_1050,w_1050,x_0,y_175/format,webp'
      ];
      setState(() {
        var userId = 1;
        //重新构建列表
        _comments.insertAll(
          _comments.length,
          //每次生成20个单词
          generateWordPairs().take(40).map((e) {
            var random = Random().nextInt(1000);

            return CommentModel(
              content: e.asPascalCase,
              date: DateTime.now(),
              supportNum: random,
              childComments: [],
              user: UserModel(
                  id: (userId++).toString(),
                  nick: random % 2 == 0 ? '123' : e.asPascalCase,
                  headPic: pics[random % 2],
              )
            );
          }).toList(),
        );
      });
    });
  }

  renderEditingOptions() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(

            )
        ),
        Expanded(
          flex: 1,
          child: Container(

          ),
        ),
      ],
    );
  }
}
