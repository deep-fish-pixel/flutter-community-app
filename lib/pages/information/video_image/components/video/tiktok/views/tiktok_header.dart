import 'package:flutter/material.dart';
import 'package:gardener/constants/gardener_icons.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:tapped/tapped.dart';

import 'select_text.dart';

class TikTokHeader extends StatefulWidget {
  final Function? onSearch;
  const TikTokHeader({
    Key? key,
    this.onSearch,
  }) : super(key: key);

  @override
  _TikTokHeaderState createState() => _TikTokHeaderState();
}

class _TikTokHeaderState extends State<TikTokHeader> {
  int currentSelect = 0;
  @override
  Widget build(BuildContext context) {
    List<String> list = ['推荐', '本地'];
    List<Widget> headList = [];
    for (var i = 0; i < list.length; i++) {
      headList.add(Expanded(
        child: GestureDetector(
          child: Container(
            child: SelectText(
              title: list[i],
              isSelect: i == currentSelect,
            ),
          ),
          onTap: () {
            setState(() {
              currentSelect = i;
            });
          },
        ),
      ));
    }
    Widget headSwitch = Row(
      children: headList,
    );
    return Container(
      // color: Colors.black.withOpacity(0.3),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Tapped(
              child: Container(
                color: Colors.black.withOpacity(0),
                padding: EdgeInsets.all(4),
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white.withOpacity(0.66),
                ),
              ),
              onTap: widget.onSearch,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black.withOpacity(0),
              alignment: Alignment.center,
              child: Text(''),
            ),
          ),
          Expanded(
            child: Tapped(
              child: Container(
                color: Colors.black.withOpacity(0),
                padding: EdgeInsets.all(4),
                alignment: Alignment.centerRight,
                child: Icon(
                  GardenerIcons.transmit,
                  color: Colors.white.withOpacity(0.66),
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
