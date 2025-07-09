import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gardener/constants/gardener_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/tiktok_comment_bottom_sheet.dart';

class BottomBar extends StatefulWidget {
  final Function? onShowComments;

  const BottomBar({
    Key? key,
    this.onShowComments
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar>  {
  bool editing = false;
  TextEditingController editingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    editingController.addListener((){
      print('control======: ${editingController.text}');
    });
    // 设置field默认值
    // editingController.text="hello world!";
    // 判断焦点
    focusNode.addListener((){
      print('focusNode======: ${focusNode.hasFocus}');
      if(focusNode.hasFocus){
        setState(() => {
          editing = true
        });
      } else {
        setState(() => {
          editing = false
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: editing ? 10 : 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0), //3像素圆角
                  border: Border.all(width: 3, color: Colors.grey.shade200),
                ),
                height: 35.0,
                // color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: renderTextField(context),
                  ),
                ),
              )
          ),
          editing ? Expanded(
            flex: 5,
            child: Container(
              height: 50.0,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: TextButton(
                      child: Text("@", style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54
                      ),),
                      onPressed: () {
                        EasyLoading.showToast('显示 关注+好友+物业+业委会等账号');
                      },
                    ),
                    width: 60,
                  ),
                  Container(
                      height: 26.0,
                      child: ElevatedButton(
                        child: Text("发送"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(ThemeColors.main),                //背景颜色
                          foregroundColor: MaterialStateProperty.all(Colors.white),                //字体颜色
                          overlayColor: MaterialStateProperty.all(Color(0xffFF7F24)),                   // 高亮色
                          shadowColor: MaterialStateProperty.all( ThemeColors.main),                  //阴影颜色
                          elevation: MaterialStateProperty.all(0),                                     //阴影值
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),              //字体
                          side: MaterialStateProperty.all(const BorderSide(
                              width: 1,
                              color: Color(0x00C7C7C7)
                          )
                          ),//边框
                          shape: MaterialStateProperty.all(
                              const StadiumBorder(
                                  side: BorderSide(
                                    //设置 界面效果
                                    style: BorderStyle.solid,
                                    color: Color(0xffFF7F24),
                                  )
                              )
                          ),//圆角弧度
                        ),
                        onPressed: () {
                          EasyLoading.showToast('发送内容');
                        },
                      )
                  )
                ],
              ),
            ),
          ) : renderComments(context) ,
        ],
      ),
    );
  }

  renderTextField(context){
    return TextField(
      autofocus: false,
      controller: editingController,
      // 控制焦点事件
      focusNode: focusNode,
      style: const TextStyle(
        backgroundColor: Colors.white
      ),
      maxLines: 1,
      // onChanged: (value) {
      //   print('onChanged ${value}');
      // },
      decoration: InputDecoration(
        isDense: true,
        icon: Container(
          color: Colors.white,
          width: 30,
          child: const Icon(
            GardenerIcons.edit,
            size: 24,
            color: Colors.black87,
          ),
        ),
        iconColor: Colors.white,
        contentPadding: const EdgeInsets.only(
            left: -16, right: 4, top: 4, bottom: 0
        ),
        suffixStyle: const TextStyle(
            backgroundColor: Colors.white
        ),
        prefixStyle: const TextStyle(
            backgroundColor: Colors.white
        ),
        border: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
        hintStyle: const TextStyle(
          color: Color(0xffcccccc),
          fontSize: 14,
        ),
        hintText: "说点什么"
      ),
    );
  }

  renderComments(context){
    return Expanded(
      flex: 3,
      child: Container(
        height: 50.0,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton(
              onPressed: (){
                EasyLoading.showToast('喜欢');
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(color: Colors.black87, fontSize: 14),
                ),
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.black87;
                }),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    GardenerIcons.like,
                    size: 32,
                    color: Colors.white,
                  ),
                  Flexible(child: Text(
                    "6172",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ))
                ],
              ),
            ),
            TextButton(
              onPressed: (){
                EasyLoading.showToast('收藏');
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(color: Colors.black87, fontSize: 14),
                ),
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.black87;
                }),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    GardenerIcons.mark,
                    size: 32,
                    color: Colors.white,
                  ),
                  Flexible(child: Text(
                    "6172",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ))
                ],
              ),
            ),
            TextButton(
              onPressed: (){
                EasyLoading.showToast('查看评论', duration: Duration(milliseconds: 300));
                /*showModalBottomSheet(
                  backgroundColor: Colors.white.withOpacity(0),
                  context: context,
                  builder: (BuildContext context) => const TikTokCommentBottomSheet(),
                );*/
                widget.onShowComments!();
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(color: Colors.black87, fontSize: 14),
                ),
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.black87;
                }),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    GardenerIcons.edit,
                    size: 32,
                    color: Colors.white,
                  ),
                  Flexible(
                    child: Text(
                      "6172",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}