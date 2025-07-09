import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:gardener/components/ui.dart';
import 'package:gardener/constants/constant.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/contants_page/common/models.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/check.dart';
import 'package:gardener/util/win_media.dart';
import 'package:flutter/material.dart';

import 'image_view.dart';

class ChatMembers extends StatefulWidget {
  List<ContactInfo> list;
  bool activity;
  bool spread;
  bool card;

  ChatMembers({
    Key? key,
    required this.list,
    this.activity = false,
    this.spread = true,
    this.card = false
  }) : super(key: key);

  @override
  _ChatMembersState createState() => _ChatMembersState();
}

class _ChatMembersState extends State<ChatMembers> {
  @override
  Widget build(BuildContext context) {

    List<Widget> wrap = [];
    var count = 0;

    widget.list.every((contactInfo) {
      if (!widget.activity || !widget.spread || widget.activity && count++ < 10) {
        wrap.add(InkWell(
          child: SizedBox(
            width: 55.0,
            child: Column(
              children: <Widget>[
                ImageView(
                  img: contactInfo.img ?? 'assets/images/def_avatar.png',
                  width: 55.0,
                  height: 55.0,
                  fit: BoxFit.cover,
                  radius: 55,
                ),
                Space(height: Constant.mainSpace / 2),
                widget.spread && widget.list.length > 5 ? Container() : Text(
                  contactInfo.name,
                  style: const TextStyle(color: ThemeColors.mainGray),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          onTap: () {
            if (widget.spread && !widget.card) {
              setState(() {
                widget.spread = false;
              });
            }
          },
          onDoubleTap: () {
            if (!widget.card) {
              setState(() {
                widget.spread = !widget.spread;
              });
            }
          },
        ));
      }

      return true;
    });

    if (!widget.activity) {
      wrap.add(
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
              style: BorderStyle.solid
            ),
            borderRadius: const BorderRadius.all(Radius.circular(55))
          ),
          child: IconButton(
            color: Colors.green,
            icon: const Icon(
              Icons.add,
              size: 30,
              color: ThemeColors.mainGray,
            ),
            onPressed: () => {
              RouteUtil.push(
                context,
                RoutePath.groupLaunchPage,
                params: widget.list
              )
            },
          )
        )
      );
    }



    return Container(
      color: Colors.white,
      width: winWidth(context),
      height: widget.spread ? 96 : min(((widget.list.length + 1) / 6).ceil(), 4) * 96,
      padding: const EdgeInsets.only(left: 10.0, right: 6),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: widget.spread ? Axis.horizontal : Axis.vertical,

                  child: Wrap(
                    spacing: getSpacing(widget.list.length) ,
                    runSpacing: 8.0,
                    children: wrap,
                  ),
                ),
              ),
            ),
          ),
          widget.activity ? Container(
            margin: const EdgeInsets.only(left: 10),
            // color: Colors.red,
            alignment: Alignment.centerRight,
            height: 55,
            width: 58,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${widget.list.length}/40',
                  style: const TextStyle(
                    color: ThemeColors.mainGray,
                  )
                ),
                widget.card ? Container(width: 14,) : Icon(
                  CupertinoIcons.right_chevron,
                  color: ThemeColors.mainGray.withOpacity(0.5),
                )
              ],
            )
          ) : Container()
        ],
      ),
    );
  }

  getSpacing(int length){
    if (!widget.spread) {
      return 10.0;
    }
    if (length < 5) {
      return 10.0;
    }
    if (length > 5) {
      return -1.2 * length;
    }
    return 0.0;
  }
}
