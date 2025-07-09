import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:gardener/models/message/message_normal.dart';
import 'package:gardener/pages/message/constant.dart';

class ChatModel {
  String content;
  bool isMe;

  ChatModel(this.content, {this.isMe = false});
}

class ItemModel {
  String title;
  IconData icon;
  String value;

  ItemModel(this.title, this.icon, this.value);
}

class MessageOperations {
  static ItemModel copy = ItemModel('复制', Icons.content_copy, '1');
  static ItemModel forwarding = ItemModel('转发', Icons.send, '2');
  static ItemModel collections = ItemModel('收藏', Icons.collections, '3');
  static ItemModel format_quote = ItemModel('引用', Icons.format_quote, '4');
  static ItemModel delete = ItemModel('删除', Icons.delete, '5');
  static ItemModel redo = ItemModel('撤回', Icons.redo, '6');
}

// ignore: must_be_immutable
class MessagePopMenu extends StatelessWidget {
  Widget child;
  String type;
  HrlMessage message;
  final Function(ItemModel, HrlMessage)? onSelected;


  final CustomPopupMenuController _controller = CustomPopupMenuController();

  List<ItemModel> menuItems = [];

  MessagePopMenu({
    Key? key,
    required this.child,
    required this.type,
    this.onSelected,
    required this.message,
  }) : super(key: key) {
    if (type == HrlMessageType.text) {
      menuItems = [
        MessageOperations.copy,
        MessageOperations.forwarding,
        MessageOperations.collections,
        MessageOperations.format_quote,
        MessageOperations.delete,
        MessageOperations.redo,
      ];
    } /*else if (type == HrlMessageType.voice) {
      menuItems = [
        MessageOperations.collections,
        MessageOperations.format_quote,
        MessageOperations.delete,
        MessageOperations.redo,
      ];
    } */else {
      menuItems = [
        MessageOperations.forwarding,
        MessageOperations.collections,
        MessageOperations.format_quote,
        MessageOperations.delete,
        MessageOperations.redo,
      ];
    }
  }


  Widget _buildLongPressMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 50.0 * menuItems.length,
        color: const Color(0xFF4C4C4C),
        child: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          crossAxisCount: menuItems.length,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: menuItems.map((item) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              print("onTap");
              if(onSelected != null) {
                onSelected!(item, message);
              }
              _controller.hideMenu();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  item.icon,
                  size: 20,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ]
            )
          )).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      menuBuilder: _buildLongPressMenu,
      barrierColor: Colors.transparent,
      pressType: PressType.longPress,
      controller: _controller,
      child: child,
    );
  }
}


