import 'package:flutter/material.dart';
import 'package:gardener/constants/remix_icons.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/models/base/KeyValue.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


List<KeyValue> getVisibilityItems(){
 return [
   KeyValue(
     key: '所有人可见',
     value: '1',
     icon: const Icon(RemixIcons.riLockUnlockLine),
     checked: true
   ),
   KeyValue(
     key: '仅自己可见',
     value: '2',
     icon: const Icon(RemixIcons.riLockLine)
   ),
 ];
}


void showVisiblityModel(BuildContext context, List<KeyValue> visibilityItems, onSelected){
  showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Material(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    '设置可见性',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                ...visibilityItems.map((e) => ListTile(
                  title: Text(e.key),
                  trailing: e.checked ? const Icon(RemixIcons.riCheckLine, color: ThemeColors.main,) : null,
                  onTap: () {
                    visibilityItems.forEach((element) {
                      element.checked = false;
                    });
                    e.checked = false;
                    onSelected(e);
                    Navigator.of(context).pop();
                  },
                )).toList(),
              ],

            ),
          )
        )
      )
  );
}