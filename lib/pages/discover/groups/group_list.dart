import 'package:flutter/material.dart';
import 'package:gardener/components/button_main.dart';
import 'package:gardener/constants/themes.dart';

class GroupListWidget extends StatelessWidget {
  const GroupListWidget(this.tabKey, {this.scrollDirection = Axis.vertical});
  final String tabKey;
  final Axis scrollDirection;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext c, int index) {
        bool hasApplied = index % 3 == 0;

        return Container(
          //decoration: BoxDecoration(border: Border.all(color: Colors.orange,width: 1.0)),
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 6, bottom: 6),
          height: 86.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 15, right: 15),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                  radius: 25,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "独为伊人醉红尘",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: ThemeColors.main,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child: Row(
                                    children: <Widget>[
                                      ButtonMain(text: 'Lv18', height: 16, width: 40, backgroundColor: Color(0xFFFF592F), margin: EdgeInsets.only(right: 10), onPressed: (text){ }),
                                      ButtonMain(text: '31人', height: 16, width: 40, backgroundColor: Color(0xFF00D7E8), margin: EdgeInsets.only(right: 10), onPressed: (text){ }),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child: const Text(
                                    "得之坦然，失之淡然，争其必然，争其必然",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: UnconstrainedBox( //“去除”父级限制
                            child: Container(
                              width: hasApplied ? 74 : 60,
                              margin: EdgeInsets.only(right: 10),
                              child: hasApplied ? ButtonMain(text: '已申请', theme: ButtonMain.themeDisabled, onPressed: (text){ },) : ButtonMain(text: '加入', onPressed: (text){ }),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 0.5,
                          color: Color(0xffE5E5E5),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          );
      },
      itemCount: 100,
      scrollDirection: scrollDirection,
    );
  }
}
