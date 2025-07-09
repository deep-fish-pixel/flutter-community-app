import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/blog/user_model.dart';
import 'package:gardener/pages/information/information_page.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:tapped/tapped.dart';

class InformationTopicPage extends StatefulWidget {
  const InformationTopicPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return InformationTopicState();
  }
}

class InformationTopicState extends State<InformationTopicPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _communityInputNode = FocusNode();
  late TextEditingController _communityInputController;
  String seachKeyword = '';
  bool isMore = false;
  List<UserModel> userModelOrigList = [];
  List<UserModel> userModelList = [];

  @override
  initState() {
    super.initState();
    _communityInputController = TextEditingController();
    userModelOrigList = userModelListData.slice(0);
    userModelList = userModelOrigList;
  }

  @override
  Widget build(BuildContext context) {
    print('=========================InformationTopicState');
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
              autofocus: false,
              focusNode: _communityInputNode,
              controller: _communityInputController,
              onChanged: (value) {
                print('onChanged====$value');
                seachKeyword = value;
                if (seachKeyword.isNotEmpty) {
                }
                setState(() {});
              },
              onTapOutside: (e) => {
                _communityInputNode.unfocus()
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
                  hintText: '请输入话题关键字',
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
        child: renderRecentTopics(),
      );
    }

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: renderRelativeTopics(),
    );
  }

  renderRecentTopics() {
    return ListView.separated(
      itemCount: userModelList.length + 1,
      //列表项构造器
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          if (seachKeyword.isEmpty) {
            return Container(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              color: ThemeColors.mainGrayBitBackground,
              child: const Text('推荐话题',
                style: TextStyle(
                  color: ThemeColors.mainGray,
                  fontSize: 12,
                ),),
            );
          }
          return Container();
        }
        return renderItem(userModelList[index - 1]);
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return Container();
      },
    );
  }

  renderRelativeTopics() {
    List<UserModel> filters = userModelList.where((element) => element.nick.indexOf(seachKeyword) >= 0).toList();

    return ListView.separated(
      itemCount: filters.length,
      //列表项构造器
      itemBuilder: (BuildContext context, int index) {
        return renderItem(filters[index]);
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return Container();
      },
    );
  }

  renderItem(UserModel userModel){
    return Tapped(
      onTap: (){
        RouteUtil.pop(context, userModel);
      },
      child: ListTile(
        style: ListTileStyle.list,
        dense: false,
        title: Text(
          '#   ${userModel.nick}',
          style: const TextStyle(
            fontSize: 16,
            color: ThemeColors.mainBlack,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.start,
        ),
        trailing: Container(
          width: 140,
          alignment: Alignment.centerRight,
          child: const Text(
            '81万次引用',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.mainGray,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }


  @override
  dispose(){
    super.dispose();
  }
}