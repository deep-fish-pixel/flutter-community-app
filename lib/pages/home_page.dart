import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/components/route/bottom_page_route.dart';
import 'package:gardener/pages/discover/discover_page.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/toast.dart';
import 'package:gardener/util/win_media.dart';
import 'package:toast/toast.dart';
import '/constants/themes.dart';
import 'information/information_page.dart';
import 'information/user_create/information_create_page.dart';
import 'login_model_bottom_sheet.dart';
import 'message/message_main_page.dart';
import 'mine/user-page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _avatarKey = GlobalKey();

  List<Widget> pages = [
    const InformationPage(),
    const MessageMainPage(),
    DiscoverPage(),
    UserPage()
  ];

  @override
  void initState() {
    super.initState();
  }


  void _setSelectedIndex(BuildContext context, index) {
    if (index > 0 && checkShowLoginModel(context)) {
      return;
    }
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _selectedIndex = index;
      informationPageActiveNotifier.setActive(index == 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    winWidth(context);
    winHeight(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Material(
      child: Scaffold(
        body: CupertinoPageScaffold(
            child: IndexedStack(
              index: _selectedIndex,
              children: pages,
            )
        ),
        bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            // shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getBottomBar(
                    icon: const Icon(Icons.home),
                    text: '首页',
                    active: _selectedIndex == 0,
                    onPressed: () {
                      _setSelectedIndex(context, 0);
                    }
                ),
                getBottomBar(
                    icon: const Icon(Icons.message_outlined),
                    text: '消息',
                    active: _selectedIndex == 1,
                    onPressed: () {
                      _setSelectedIndex(context, 1);
                    }
                ),
                Container(
                  width: 40,
                  child: FloatingActionButton(
                    key: _avatarKey,
                    onPressed: () async {
                      if (checkShowLoginModel(context)) {
                        return;
                      }
                      // RouteUtil.push(context, RoutePath.createInformationPage);
                      await Navigator.push(
                        context,
                        CircularClipRoute<void>(
                            builder: (context) => const InformationCreatePage(),
                            expandFrom: _avatarKey.currentContext!,
                            curve: Curves.fastOutSlowIn,
                            reverseCurve: Curves.fastOutSlowIn.flipped,
                            opacity: ConstantTween(1),
                            transitionDuration: const Duration(milliseconds: 500),
                            maintainState: true
                        ),
                      );
                      // Navigator.push(context, BottomPageRoute(widget, const CreateInformationPage()));
                    },
                    mini: true,
                    tooltip: 'Increment',
                    child: Icon(Icons.add),
                  ),
                ),
                getBottomBar(
                    icon: const Icon(Icons.explore),
                    text: '发现',
                    active: _selectedIndex == 2,
                    onPressed: () {
                      _setSelectedIndex(context, 2);
                    }
                ),
                getBottomBar(
                    icon: Icon(Icons.account_circle),
                    text: '我的',
                    active: _selectedIndex == 3,
                    onPressed: () {
                      _setSelectedIndex(context, 3);
                    }
                ),
              ], //均分底部导航栏横向空间
            )
        ),
        /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), //
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,*/
// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  getBottomBar({
    required Icon icon,
    required String text,
    required bool active,
    Null Function()? onPressed
}) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 6),
            child: Text(text,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: active ? ThemeColors.main : ThemeColors.black02
              ),
            ),
          ),
          Container(
            height: 36,
            // width: 30,
            // color: Colors.green,
            child: IconButton(
              icon: icon,
              onPressed: () {
                if (onPressed != null) {
                  onPressed();
                }
              },
              color: active ? ThemeColors.main : null,
              padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 10),
            ),
          ),

        ],
      ),
    );
  }

}