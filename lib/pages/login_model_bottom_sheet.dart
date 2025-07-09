import 'package:flutter/material.dart';
import 'package:gardener/pages/account/login_page.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'account/util/sp_keys.dart';

void showLoginModelBottomSheet(context) {
  showCupertinoModalBottomSheet(
    expand: true,
    context: context,
    backgroundColor: Colors.green,
    builder: (context) => const LoginPage(),
  );
}

bool checkLogin() {
  bool? hasLogin = SharedUtil.getBoolean(SPKeys.hasLogin);
  return hasLogin == true;
}

bool checkShowLoginModel(context) {
  if (checkLogin()) {
    return false;
  } else {
    showLoginModelBottomSheet(context);
    return true;
  }
}