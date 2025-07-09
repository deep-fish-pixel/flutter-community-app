import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/contants_page/common/models.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../contants_page/common/index.dart';


class WeChatItem extends StatefulWidget {
  ContactInfo model;
  double? susHeight = 40;
  Color? defHeaderBgColor;
  void Function(ContactInfo model)? onChange;

  WeChatItem({
    Key? key,
    required this.model,
    this.susHeight,
    this.defHeaderBgColor,
    this.onChange
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WeChatItemState();
  }
}

class WeChatItemState extends State<WeChatItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 80,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: RoundCheckBox(
                size: 24,
                checkedWidget: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
                checkedColor: ThemeColors.main,
                border: Border.all(
                    width: widget.model.checked == true ? 0 : 0.5,
                    color: ThemeColors.mainGray
                ),
                isChecked: widget.model.checked,
                onTap:(value){
                  onChange();
                } ,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(18.0),
                color: widget.model.bgColor ?? widget.defHeaderBgColor,
              ),
              child: widget.model.iconData == null
                  ? Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              )
                  : Icon(
                widget.model.iconData,
                color: Colors.white,
                size: 20,
              ),
            )
          ],
        ),
      ),
      title: Text(widget.model.name),
      onTap: () {
        LogUtil.e("onItemClick : ${widget.model}");
        Utils.showSnackBar(context, 'onItemClick : ${widget.model}');
        setState(() {
          onChange();
        });
      },
    );;
  }

  void onChange(){
    print('onItemClick : ${widget.model}');
    widget.model.checked = (widget.model.checked == null || widget.model.checked == false);
    widget.onChange!(widget.model);
  }

}