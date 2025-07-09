import 'package:flutter/material.dart';
import 'package:gardener/pages/message/contants_page/common/models.dart';

class ChatAddUserToGroup extends StatefulWidget {
  List<ContactInfo> users;

  ChatAddUserToGroup({
    Key? key,
    required this.users
  }) : super(key: key);

  @override
  _ChatAddUserToGroupState createState() => _ChatAddUserToGroupState();
}

class _ChatAddUserToGroupState extends State<ChatAddUserToGroup> {
  final globalKey = GlobalKey<AnimatedListState>();
  final ScrollController listScrollController = ScrollController();
  int lastLength = -1;

  @override
  didChangeDependencies(){
    print('didChangeDependencies====');
  }

  @override
  Widget build(BuildContext context) {
    print('==============_ChatAddUserToGroupState ${widget.users.length}');
    updateCurrentState();

    return SizedBox(
      height: 50,
      child: AnimatedList(
        controller: listScrollController,
        scrollDirection: Axis.horizontal,
        key: globalKey,
        // initialItemCount: widget.users.length,
        initialItemCount: widget.users.length + 1,
        itemBuilder: (
            BuildContext context,
            int index,
            Animation<double> animation,
            ) {
          //添加列表项时会执行渐显动画
          return FadeTransition(
            opacity: animation,
            child: buildItem(context, index),
          );
          // return ListTile(title: Text("$index"));
          // return buildItem(context, index);
        },
      ),
      /*child: ListView.builder(
          itemCount: widget.users.length,
          itemExtent: 50.0, //强制高度为50.0
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text("$index"));
          }
      )*/
    );
  }

  // 构建列表项
  Widget buildItem(context, index) {
    if (index < widget.users.length) {
      return Padding(
        padding: EdgeInsets.only(right: 5.0, left: 10),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg"),
              radius: 16.0,
            ),
            // Text(widget.users[index].name)
          ],
        ),
      );
    }

    return Container();
  }

  updateCurrentState(){
    var currentState = globalKey.currentState;
    if (lastLength == -1) {
      lastLength = widget.users.length;
    }
    if (currentState != null) {
      if (lastLength < widget.users.length) {
        List.generate(widget.users.length - lastLength, (index) => {
          currentState.insertItem(lastLength + index)
        });
        lastLength = widget.users.length;
        listScrollController.animateTo(lastLength * 31,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
      if (lastLength > widget.users.length) {
        var index = lastLength - 1;
        currentState.removeItem(index, (context, animation) {
          listScrollController.animateTo(index * 47,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut);
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              //让透明度变化的更快一些
              curve: const Interval(0.5, 1.0),
            ),
            // 不断缩小列表项的高度
            child: Container()
          );
        });
        lastLength = widget.users.length;
      }

      // currentState!.insertItem(widget.users.length - 1);

    }
    /*globalKey.currentState!.removeItem(
      index,
          (context, animation) {
        // 删除过程执行的是反向动画，animation.value 会从1变为0
        var item = buildItem(context, index);
        print('删除 ${data[index]}');
        data.removeAt(index);
        // 删除动画是一个合成动画：渐隐 + 缩小列表项告诉
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            //让透明度变化的更快一些
            curve: const Interval(0.5, 1.0),
          ),
          // 不断缩小列表项的高度
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0.0,
            child: item,
          ),
        );
      },
      duration: Duration(milliseconds: 200), // 动画时间为 200 ms
    );*/
  }
}