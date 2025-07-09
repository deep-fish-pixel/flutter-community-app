import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/constants/gardener_icons.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/contants_page/common/index.dart';
import 'package:gardener/pages/message/contants_page/src/az_common.dart';
import 'package:gardener/pages/message/contants_page/src/az_listview.dart';
import 'package:gardener/pages/message/contants_page/src/index_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tapped/tapped.dart';

class SelectCommunityCityPage extends StatefulWidget {
  const SelectCommunityCityPage({Key? key}) : super(key: key);

  @override
  _SelectCommunityCityPageState createState() =>
      _SelectCommunityCityPageState();
}

class _SelectCommunityCityPageState extends State<SelectCommunityCityPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  late TextEditingController textEditingController;

  List<CityModel> originCityList = [];
  List<CityModel> cityList = [];
  double susItemHeight = 36;
  String imgFavorite = Utils.getImgPath('ic_favorite');


  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void loadData() async {
    //加载城市列表
    rootBundle.loadString('assets/data/china.json').then((value) {
      originCityList.clear();
      Map countyMap = json.decode(value);
      List list = countyMap['china'];
      list.forEach((v) {
        originCityList.add(CityModel.fromJson(v));
      });
      print('loadData====');
      _handleList(originCityList);
    });
  }

  void _handleList(List<CityModel> list) {
    print('_handleList====');
    cityList.clear();
    if (ObjectUtil.isEmpty(list)) {
      setState(() {});
      return;
    }
    cityList.addAll(list);
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp('[A-Z]').hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = '#';
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(cityList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(cityList);

    // add header.
    if (textEditingController.value.text.isEmpty) {
      cityList.insert(
          0,
          CityModel(
              name: 'header',
              tagIndex: imgFavorite
          )
      );
    }

    setState(() {});
  }

  Widget _buildHeader() {
    List<CityModel> hotCityList = [];

    hotCityList.addAll([
      CityModel(name: "北京市"),
      CityModel(name: "上海市"),
      CityModel(name: "广州市"),
      CityModel(name: "深圳市"),
      CityModel(name: "成都市"),
      CityModel(name: "杭州市"),
      CityModel(name: "武汉市"),
      CityModel(name: "南京市"),
    ]);
    if (textEditingController.value.text.isNotEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 10.0,
        children: hotCityList.map((e) {
          return OutlinedButton(
            style: const ButtonStyle(
              //side: BorderSide(color: Colors.grey[300], width: .5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Text(
                  e.name,
                style: const TextStyle(
                  color: ThemeColors.mainBlack
                ),
              ),
            ),
            onPressed: () {
              print("OnItemClick: $e");
              Navigator.pop(context, e);
            },
          );
        }).toList(),
      ),
    );
  }

  void _search(String text) {
    if (ObjectUtil.isEmpty(text)) {
      _handleList(originCityList);
    } else {
      List<CityModel> list = originCityList.where((v) {
        return v.name.toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              child: Row(
                children: [
                  Tapped(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 225, 226, 230), width: 0.33),
                          color: const Color.fromARGB(255, 239, 240, 244),
                          borderRadius: BorderRadius.circular(24)),
                      child: TextField(
                        autofocus: false,
                        onChanged: (value) {
                          _search(value);
                        },
                        controller: textEditingController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            RemixIcons.search,
                            color: ThemeColors.mainGray33,
                            size: 20,
                          ),
                          prefixIconConstraints: null,
                          suffixIcon: Offstage(
                            offstage: textEditingController.text.isEmpty,
                            child: GestureDetector(
                              onTap: () {
                                textEditingController.clear();
                                _search('');
                              },
                              child: const Icon(
                                Icons.cancel,
                                color: ThemeColors.mainGray99,
                              ),
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: '请输入城市名称搜索',
                          hintStyle: const TextStyle(
                            color: ThemeColors.mainGray99,
                            height: 1
                          )
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    title: Text("当前城市"),
                    trailing: GestureDetector(
                      onTap: (){
                        Navigator.pop(context, cityList[1]);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Icon(
                            RemixIcons.mapPin2Line,
                            size: 16.0,
                          ),
                          Text("成都市"),
                        ],
                      ),
                    )
                  ),
                  const Divider(
                    height: .0,
                  ),
                  Expanded(
                    child: AzListView(
                      data: cityList,
                      itemCount: cityList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) return _buildHeader();
                        CityModel model = cityList[index];
                        return Utils.getListItem(context, model,
                            susHeight: susItemHeight);
                      },
                      susItemHeight: susItemHeight,
                      susItemBuilder: (BuildContext context, int index) {
                        CityModel model = cityList[index];
                        String tag = model.getSuspensionTag();
                        if (imgFavorite == tag) {
                          return Container();
                        }
                        return Utils.getSusItem(context, tag, susHeight: susItemHeight);
                      },
                      indexBarData: SuspensionUtil.getTagIndexList(cityList),
                      indexBarOptions: IndexBarOptions(
                        needRebuild: true,
                        ignoreDragCancel: true,
                        localImages: [imgFavorite],
                        downTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
                        downItemDecoration:
                        const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
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
                  ),
                ],
              )
            )
          ]
        )
      )
    );
  }
}
