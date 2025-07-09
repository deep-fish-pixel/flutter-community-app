import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/models/blog/user_model.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:gardener/routes/index.dart';
import 'package:super_editor/super_editor.dart';

class TextEditor extends StatefulWidget {
  final FocusNode focusNode;

  const TextEditor({
    Key? key,
    required this.focusNode
  }) : super(key: key);

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> with WidgetsBindingObserver {
  bool bottomHidden = false;

  OverlayEntry? _popupEntry;

  Offset _popupOffset = Offset.zero;

  late AttributedTextEditingController _textFieldController;

  String lastText = '';

  List<NamedAttributionIndex> namedAttributionIndexes = [];

  // 当前键盘是否是激活状态
  bool isKeyboardActived = false;

  int lastKeyboardStartTime = 0;


  @override
  void initState() {
    print('======================initState');
    super.initState();
    widget.focusNode.addListener((){
      print('_descFocusNode.hasFocus========' + widget.focusNode.hasFocus.toString());
      setState(() {
        bottomHidden = widget.focusNode.hasFocus;
      });
    });

    _textFieldController = AttributedTextEditingController(
      text: AttributedText(
          text: 'Super Editor1 is an open source text editor for Flutter projects.',
        ),
    );

    _textFieldController.addListener(() {
      String currentText = _textFieldController.text.text;
      if (lastText != currentText) {
        resetWordsHighlight();
      }
      lastText = currentText;
      resetCusorIndex();
    });

    WidgetsBinding.instance.addObserver(this);

    Future.delayed(const Duration(seconds: 3), () {
      // _textFieldController.delete(from: 0, to: 2);
      // _textFieldController.text.spans.removeAttribution(attributionToRemove: flutterAttribution, start: 47, end: 53);
      // int openIndex = _textFieldController.text.text.indexOf('open');
      // _textFieldController.text.spans.addAttribution(newAttribution: openAttribution, start: openIndex, end: openIndex + 4);
      /*setState(() {
      _textFieldController.selection.end
        _textFieldController.selection = TextSelection.fromPosition(TextPosition(offset: 10));

      });*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            // FocusScope.of(context).requestFocus(_descFocusNode);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: SuperDesktopTextField(
              textController: _textFieldController,
              inputSource: TextInputSource.ime,
              focusNode: widget.focusNode,
              textStyleBuilder: _textStyleBuilder,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decorationBuilder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white,
                      width: 0,
                    ),
                  ),
                  child: child,
                );
              },
              hintBuilder: (context) {
                return const Text(
                  '输入我的看法',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                );
              },
              hintBehavior: HintBehavior.displayHintUntilTextEntered,
              minLines: 4,
              maxLines: 4,
              onRightClick: _onRightClick,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Row(
            children: [
              ButtonMain(
                  text: "@朋友",
                  theme: ButtonMain.themeGreyConfirm,
                  fontWeight: FontWeight.w700,
                  onPressed: (text) async {
                    /*if (widget.focusNode.hasFocus) {
                      _textFieldController.insert(newText: AttributedText(text: '@人生  '), insertIndex: _textFieldController.selection.start);
                    } else {
                      _textFieldController.insert(newText: AttributedText(text: '@人生  '), insertIndex: _textFieldController.text.text.length);
                    }*/
                    resetWordsHighlight();
                    UserModel model = await RouteUtil.push(context, RoutePath.informationPersionPage);

                    if (widget.focusNode.hasFocus) {
                      _textFieldController.insert(newText: AttributedText(text: '@${model.nick}  '), insertIndex: _textFieldController.selection.start);
                    } else {
                      _textFieldController.insert(newText: AttributedText(text: '@${model.nick}  '), insertIndex: _textFieldController.text.text.length);
                    }
                  }
              ),
              ButtonMain(
                  text: "#话题",
                  margin: const EdgeInsets.only(left: 10),
                  theme: ButtonMain.themeGreyConfirm,
                  fontWeight: FontWeight.w700,
                  onPressed: (text) async {
                    resetWordsHighlight();
                    UserModel model = await RouteUtil.push(context, RoutePath.informationTopicPage);

                    if (widget.focusNode.hasFocus) {
                      _textFieldController.insert(newText: AttributedText(text: '#${model.nick}# '), insertIndex: _textFieldController.selection.start);
                    } else {
                      _textFieldController.insert(newText: AttributedText(text: '#${model.nick}# '), insertIndex: _textFieldController.text.text.length);
                    }
                  }
              ),
            ]
          ),
        ),
      ],
    );
  }

  TextStyle _textStyleBuilder(Set<Attribution> attributions) {
    print('_textStyleBuilder============' + attributions.length.toString());
    TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    );

    if (namedAttributionIndexes.where((element) => attributions.contains(element.attribution)).isNotEmpty) {
      textStyle = textStyle.copyWith(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      );
    }

    return textStyle;
  }

  void _onRightClick(
      BuildContext textFieldContext, AttributedTextEditingController textController, Offset localOffset) {
    // Only show menu if some text is selected
    if (textController.selection.isCollapsed) {
      return;
    }

    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    final textFieldBox = textFieldContext.findRenderObject() as RenderBox;
    _popupOffset = textFieldBox.localToGlobal(localOffset, ancestor: overlayBox);

    if (_popupEntry == null) {
      _popupEntry = OverlayEntry(builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (_) {
            _closePopup();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  left: _popupOffset.dx,
                  top: _popupOffset.dy,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                              text: textController.selection.textInside(textController.text.text),
                            ));
                            _closePopup();
                          },
                          child: const Text('Copy'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });

      overlay.insert(_popupEntry!);
    } else {
      _popupEntry!.markNeedsBuild();
    }
  }

  void _closePopup() {
    if (_popupEntry == null) {
      return;
    }

    _popupEntry!.remove();
    _popupEntry = null;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      // 当前是安卓系统并且在焦点聚焦的情况下
      if (duration.inMilliseconds - lastKeyboardStartTime > 1000) {
        print('=====' + duration.inMilliseconds.toString() + '=====' + (lastKeyboardStartTime.toString()) + '=====' + (duration.inMilliseconds - lastKeyboardStartTime).toString() );
        lastKeyboardStartTime = duration.inMilliseconds;
        if (Platform.isAndroid && widget.focusNode.hasFocus) {
          if (isKeyboardActived) {
            isKeyboardActived = false;
            // 使输入框失去焦点
            widget.focusNode.unfocus();
            return;
          }
          isKeyboardActived = true;
        } else {
          isKeyboardActived = widget.focusNode.hasFocus;
        }
      }
    });
  }

// 既然有监听当然也要有卸载，防止内存泄漏嘛
  @override
  void dispose() {
    super.dispose();
    widget.focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void resetWordsHighlight() {
    String value = _textFieldController.text.text;
    List<RegExpMatch> list = RegExp(r'(@[^@# ]+ |#[^#@ ]+#)').allMatches(value).toList();

    namedAttributionIndexes.forEach((element) {
      _textFieldController.text.spans.removeAttribution(attributionToRemove: element.attribution, start: element.start, end: element.end - 1);
    });

    namedAttributionIndexes = [];
    list.forEach((element) {
      NamedAttribution namedAttribution = NamedAttribution(element.input.substring(element.start, element.end));
      namedAttributionIndexes.add(NamedAttributionIndex(
        attribution: namedAttribution,
        start: element.start,
        end: element.end - 1,
      ));
      _textFieldController.text.spans.addAttribution(newAttribution: namedAttribution, start: element.start, end: element.end - 1);
    });
  }

  void resetCusorIndex() {
    // _textFieldController.selection.end
    // _textFieldController.selection = TextSelection.fromPosition(TextPosition(offset: 10));
    int start = _textFieldController.selection.start;
    int end = _textFieldController.selection.end;
    if (start == end) {
      List<NamedAttributionIndex> inAttrs = namedAttributionIndexes.where((element) => start > element.start && start <= element.end ).toList();
      if (inAttrs.isNotEmpty) {
        _textFieldController.selection = TextSelection.fromPosition(TextPosition(offset: inAttrs[0].end + 2));
        return;
      }

      List<NamedAttributionIndex> tailAttrs = namedAttributionIndexes.where((element) => start == element.end + 1 ).toList();
      if (tailAttrs.isNotEmpty) {
        String value = _textFieldController.text.text;
        if (RegExp(r' ').matchAsPrefix(value, tailAttrs[0].end + 1) == null) {
          _textFieldController.insert(newText: AttributedText(text: ' '), insertIndex: tailAttrs[0].end + 1);
        }

        _textFieldController.selection = TextSelection(
          extentOffset: tailAttrs[0].start,
          baseOffset: tailAttrs[0].end + 2,
        );
        return;
      }
    } else if(start < end) {
      List<NamedAttributionIndex> inAttrs = namedAttributionIndexes.where((element) => (start > element.start && start <= element.end) || end > element.start && end <= element.end ).toList();
      if (inAttrs.isNotEmpty) {
        _textFieldController.selection = TextSelection(
          extentOffset: inAttrs[0].start,
          baseOffset: inAttrs[0].end + 2,
        );
        return;
      }
    }
  }

}



class NamedAttributionIndex {
  final NamedAttribution attribution;
  final int start;
  final int end;

  const NamedAttributionIndex({
    required this.attribution,
    required this.start,
    required this.end,
  });
}




