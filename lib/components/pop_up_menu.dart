import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';

class PopupMenuModel<T> {
  String title;
  final T? value;
  IconData? icon;

  PopupMenuModel({
    required this.title,
    this.value,
    this.icon,
  });
}

class PopupMenu<T> extends StatefulWidget {
  final List<PopupMenuModel> menus;
  final Icon icon;
  final Color? color;
  final Function(T)? onSelected;
  final bool? reverse;

  const PopupMenu({
    Key? key,
    required this.menus,
    required this.icon,
    this.color,
    this.reverse = false,
    this.onSelected,

  }) : super(key: key);

  @override
  _PopupMenuState createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: const Color(0xFF4C4C4C),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.menus
                .map((item) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    print("onTap");
                    widget.onSelected!(item.value);
                    _controller.hideMenu();
                  },
                  child: Container(
                    height: 40,
                    padding: widget.reverse == true ? const EdgeInsets.only(right: 20) : const EdgeInsets.only(left: 20),
                    child: Row(
                      children: getMenuItem(item),
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ),
      ),
      pressType: PressType.singleClick,
      verticalMargin: -10,
      controller: _controller,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: widget.icon,
      ),
    );
  }

  getMenuItem(PopupMenuModel item){
    var list = [
      Icon(
        item.icon,
        size: 15,
        color: Colors.white,
      ),
      Expanded(
        child: Container(
          margin: EdgeInsets.only(left: widget.reverse == true ? 20: 10),
          padding: EdgeInsets.only(top: 8, bottom: 10, right: widget.reverse == true ? 10: 20),
          decoration: widget.menus.indexOf(item) != (widget.menus.length - 1) ? BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey.shade600),),
          ) : null,
          child: Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ];
    if (widget.reverse == true) {
      return list.reversed.toList();
    }
    return list;
  }
}
