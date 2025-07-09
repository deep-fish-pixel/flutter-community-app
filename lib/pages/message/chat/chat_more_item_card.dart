import 'package:gardener/components/ui.dart';
import 'package:gardener/constants/chat_constant.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/pages/message/chat/chat_more_page.dart';
import 'package:gardener/util/win_media.dart';
import 'package:flutter/material.dart';

class ChatMoreItemCard extends StatelessWidget {
  final InputMediaModel model;
  final VoidCallback onPressed;
  final double? keyboardHeight;

  ChatMoreItemCard({
    required this.model,
    required this.onPressed,
    this.keyboardHeight
  });

  @override
  Widget build(BuildContext context) {
    double margin = keyboardHeight ?? 0.0;
    double top = margin != 0.0 ? margin / 10 : 20.0;

    return Container(
      padding: EdgeInsets.only(top: top, bottom: 5.0),
      width: (winWidth(context) - 70) / 4,
      child: Column(
        children: <Widget>[
          Container(
            width: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: TextButton(
              onPressed: () {
                onPressed();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(ChatSize.radius),
                  ),
                ))
              ),
              
              /*shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              padding: const EdgeInsets.all(0),
              color: Colors.white,*/
              child: SizedBox(
                width: 50.0,
                child: model.icon,
              ),
            ),
          ),
          Space(height: 10 / 2),
          Text(
            model.title,
            style: const TextStyle(color: ThemeColors.mainGray, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
