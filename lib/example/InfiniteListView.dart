import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:gardener/pages/components/information/information_list.dart';

void main() {
  runApp(
    MaterialApp(
      // home: InfiniteListView(),
      home: Scaffold(
        body: InformationList(),
      ),
    ),
  );
}

class InfiniteListView extends StatefulWidget {
  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  double _scrollPosition = -1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _retrieveData();
    _scrollController.addListener(_scrollListener);
  }


  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
      print('_scrollPosition=======$_scrollPosition');
    });
  }

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InformationList(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    print('build========================================================');
    return Scaffold(
      body: ListView.separated(
        controller: _scrollController,
        itemCount: _words.length,
        itemBuilder: (context, index) {
          print('renderMedia========================================================$index');
          //如果到了表尾
          if (_words[index] == loadingTag) {
            //不足100条，继续获取数据
            if (_words.length - 1 < 1000) {
              //获取数据
              _retrieveData();
              //加载时显示loading
              return Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              );
            } else {
              //已经加载了100条数据，不再获取数据。
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "没有更多了",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          }
          //显示单词列表项
          return ListTile(title: Text(_words[index]));
        },
        separatorBuilder: (context, index) => Divider(height: 1.0),
      ),
    );
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      setState(() {
        //重新构建列表
        _words.insertAll(
          _words.length - 1,
          //每次生成20个单词
          generateWordPairs().take(40).map((e) => e.asPascalCase).toList(),
        );
      });
    });
  }
}