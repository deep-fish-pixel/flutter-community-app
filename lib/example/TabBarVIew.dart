import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyScrollTabListHomePage(),
    ),
  );
}

class MyScrollTabListHomePage extends StatefulWidget {
  const MyScrollTabListHomePage({Key? key}) : super(key: key);

  @override
  MyScrollTabListHomePageState createState() => MyScrollTabListHomePageState();
}

class MyScrollTabListHomePageState extends State<MyScrollTabListHomePage>
    with SingleTickerProviderStateMixin {
  final int _listItemCount = 300;
  final int _tabCount = 3;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    print('=============='+ (tabController == null).toString());

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text("AppBar"),
            ),
            //profile widget

            SliverToBoxAdapter(
              key: UniqueKey(),
              child: Container(
                color: Colors.green,
                height: 100,
                child: Center(child: Text("Profile details")),
              ),
            ),

            //tabbar
            SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: MyCustomHeader(
                  expandedHeight: kToolbarHeight,
                  tabs: TabBar(
                    controller: tabController,
                    tabs: [
                      Icon(
                        Icons.ac_unit,
                        size: 30,
                        color: Colors.black,
                      ),
                      Icon(
                        Icons.access_alarm,
                        size: 30,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  context: context
                )),
            //children
            SliverFillRemaining(
              child: TabBarView(
                controller: tabController,
                  viewportFraction: 0.01,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, int) => Text('123 $int'),
                    itemCount: 500,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, int) => Text('123 $int'),
                    itemCount: 20,
                  ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}


/// persistent header
class MyCustomHeader extends SliverPersistentHeaderDelegate {
  MyCustomHeader({
    required this.expandedHeight,
    required this.tabs,
    required this.context,
  });

  final Widget tabs;
  final double expandedHeight;
  final BuildContext context;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: tabs,
    );
  }
}

