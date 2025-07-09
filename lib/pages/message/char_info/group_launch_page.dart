import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../common/we_chat_item.dart';
import '../contants_page/src/az_common.dart';
import '../contants_page/src/az_listview.dart';
import '../contants_page/src/index_bar.dart';

import '../contants_page/common/index.dart';
import '../contants_page/common/models.dart';
import 'chat_add_user_to_group.dart';

class GroupLaunchPage extends StatefulWidget {
  const GroupLaunchPage({Key? key}) : super(key: key);

  @override
  _GroupLaunchPageState createState() => _GroupLaunchPageState();
}

class _GroupLaunchPageState extends State<GroupLaunchPage> {
  List<ContactInfo> contactList = [];
  List<ContactInfo> topList = [];
  List<ContactInfo> contactCheckedList = [];
  bool hasAddList = false;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() async {
    //加载联系人列表
    rootBundle.loadString('assets/data/car_models.json').then((value) {
      List list = json.decode(value);
      list.forEach((v) {
        contactList.add(ContactInfo.fromJson(v));
      });
      _handleList(contactList);
    });
  }

  void _handleList(List<ContactInfo> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(contactList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(contactList);

    // add topList.
    contactList.insertAll(0, topList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    addList(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('发起多人群聊'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: ChatAddUserToGroup(
            users: contactCheckedList
          ),
        ),
        actions: [
          Container(
            height: 20,
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
            child: ElevatedButton(
                onPressed: () {
                  EasyLoading.showToast('发起群聊');
                },
                child: Text('确定${contactCheckedList.length > 0? '(${contactCheckedList.length.toString()})' : ''}')
            ),
          )
        ],
      ),
      body: AzListView(
        data: contactList,
        itemCount: contactList.length,
        itemBuilder: (BuildContext context, int index) {
          ContactInfo model = contactList[index];
          return WeChatItem(
            model: model,
            defHeaderBgColor: const Color(0xFFE5E5E5),
            onChange: (ContactInfo model){
              print('onChange ${model.toString()}');
              setState(() {
                if (model.checked == true) {
                  contactCheckedList.add(model);
                } else {
                  contactCheckedList.removeWhere((element) => model.name == element.name);
                }
              });
            }
          );
        },
        physics: const BouncingScrollPhysics(),
        susItemBuilder: (BuildContext context, int index) {
          ContactInfo model = contactList[index];
          if ('↑' == model.getSuspensionTag()) {
            return Container();
          }
          return Utils.getSusItem(context, model.getSuspensionTag());
        },
        indexBarData: const ['↑', '☆', ...kIndexBarData],
        indexBarOptions: IndexBarOptions(
          needRebuild: true,
          ignoreDragCancel: true,
          downTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
          downItemDecoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          indexHintWidth: 120 / 2,
          indexHintHeight: 100 / 2,
          indexHintDecoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Utils.getImgPath('ic_index_bar_bubble_gray')),
              fit: BoxFit.contain,
            ),
          ),
          indexHintAlignment: Alignment.centerRight,
          indexHintChildAlignment: const Alignment(-0.25, 0.0),
          indexHintOffset: const Offset(-20, 0),
        ),
      ),
    );
  }

  addList(BuildContext context){
    if (!hasAddList) {
      var list = (ModalRoute.of(context)?.settings.arguments as List)[1] as List<ContactInfo>;
      print(list);
      contactCheckedList.addAll(list);
    }
    hasAddList = true;
  }
}
