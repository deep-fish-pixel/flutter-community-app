import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:gardener/util/toast.dart';
import 'package:tapped/tapped.dart';

import '../../../components/pop_up_menu.dart';
import './components/information_list.dart';

class InformationSearchPage extends StatefulWidget {
  const InformationSearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return InformationSearchState();
  }
}

class InformationSearchState extends State<InformationSearchPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _communityInputNode = FocusNode();
  late TextEditingController _communityInputController;
  String seachKeyword = '';
  bool isMore = false;
  List<String> keywordRecords = [];
  String informationSearchKeywordKey = 'InformationSearchKeywordRecords';
  bool hasDisposed = false;
  Timer? soundTimer;

  @override
  initState() {
    super.initState();
    _communityInputController = TextEditingController();
    _communityInputNode.addListener(() {
      if (!_communityInputNode.hasFocus) {
        // 存数据
        addSearchKeyword(seachKeyword);
      }
    });
    keywordRecords = SharedUtil.getStringList(informationSearchKeywordKey);
    print('keywordRecords=======' + keywordRecords.toString());
  }

  @override
  Widget build(BuildContext context) {
    print('=========================InformationSearchState');
    return  Scaffold(
      appBar: AppBar(
        leading: UnconstrainedBox(
          child: Container(
            width: 30,
            alignment: Alignment.centerLeft,
            child: IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                _communityInputNode.unfocus();
                informationPageActiveNotifier.setActive(true);
                hasDisposed = true;
                RouteUtil.pop(context);
              },
            ),
          ),
        ),
        leadingWidth: 30,
        automaticallyImplyLeading: false,
        title: Container(
          height: 36,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 225, 226, 230), width: 0.33),
            color: const Color.fromARGB(255, 239, 240, 244),
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextField(
            autofocus: true,
            focusNode: _communityInputNode,
            controller: _communityInputController,
            onChanged: (value) {
              print('onChanged====$value');
              seachKeyword = value;
              if (seachKeyword.isNotEmpty) {
              }
              setState(() {});
            },
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  RemixIcons.search,
                  color: ThemeColors.mainGray33,
                  size: 20,
                ),
                suffixIcon: Offstage(
                  offstage: _communityInputController.text.isEmpty,
                  child: InkWell(
                    onTap: () {
                      _communityInputController.clear();
                      seachKeyword = '';
                      setState(() {
                        FocusScope.of(context).requestFocus(_communityInputNode);
                      });
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: ThemeColors.mainGray99,
                    ),
                  ),
                ),
                border: InputBorder.none,
                hintText: '请输入搜索关键词',
                hintStyle: const TextStyle(
                    color: ThemeColors.mainGray99,
                    height: 1
                )
            ),
          ),
        ),
        actions: [
        ],
      ),
      body: WillPopScope(
        onWillPop: () async{
          informationPageActiveNotifier.setActive(true);
          return true;
        },
        child: Container(
          color: ThemeColors.mainGrayBitBackground,
          child: render(),
        ),
      )
    );
  }

  render(){
    if (seachKeyword.isEmpty) {
      return Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: renderKeywordRecords(),
      );
    }

    if (_communityInputNode.hasFocus) {
      return renderRelativeKeywords();
    }

    return const InformationList();
  }

  renderKeywordRecords() {
    Widget divider= const Divider(color: ThemeColors.mainGray99, height: 0.5,);
    var trimData = keywordRecords;
    var showMore = !isMore && keywordRecords.length > 3;
    if (showMore) {
      trimData = trimData.sublist(0, 3);
      trimData.add('查看全部搜索记录');
    }

    return ListView.separated(
      itemCount: trimData.length,
      //列表项构造器
      itemBuilder: (BuildContext context, int index) {
        if (showMore && index == trimData.length - 1) {
          return Container(
            child: TextButton(
              onPressed: () {
                setState(() => isMore = true);
              },
              child: Text(trimData[index]),
            ),
          );
        }
        return ListTile(
          style: ListTileStyle.list,
          dense: true,
          leading: Container(
            width: 40,
            alignment: Alignment.center,
            child: const Icon(
              RemixIcons.riHistoryLine,
              size: 16,
              color: ThemeColors.mainGray99,
            ),
          ),
          title: Tapped(
            onTap: () {
              seachKeyword = trimData[index];
              _communityInputController.text = seachKeyword;
              if (_communityInputNode.hasFocus) {
                _communityInputNode.unfocus();
              } else {
                addSearchKeyword(seachKeyword);
              }
            },
            child: Text(
                trimData[index],
              style: const TextStyle(
                fontSize: 16,
                color: ThemeColors.mainBlack
              ),
            ),
          ),
          trailing: Container(
            width: 40,
            alignment: Alignment.center,
            child: Tapped(
              onTap: () {
                keywordRecords.removeAt(index);
                setState(() => {});
              },
              child: const Icon(
                RemixIcons.riCloseLine,
                size: 16,
                color: ThemeColors.mainGray99,
              ),
            ),
          ),
        );
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return divider;
      },
    );
  }

  renderRelativeKeywords() {
    return Container(

    );
  }

  /// 存数据
  addSearchKeyword(String keyword){
    if (keyword == '' || hasDisposed) {
      return;
    }
    keywordRecords.removeWhere((element) => element == keyword);
    keywordRecords.insert(0, keyword);
    SharedUtil.saveStringList(informationSearchKeywordKey, keywordRecords);
    setState(() => {});
  }

  @override
  dispose(){
    super.dispose();
    hasDisposed = true;
    soundTimer?.cancel();
  }
}