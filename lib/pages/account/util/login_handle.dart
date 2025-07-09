import 'package:gardener/util/shared_util.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';
import 'package:gardener/provider/global_model.dart';
import 'package:gardener/util/dialog/show_toast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> init(BuildContext context) async {
  try {
    var result = await im.init(appId);
    debugPrint('初始化结果 ======>   ${result.toString()}');
  } on PlatformException {
    showToast("初始化失败");
  }
}

Future<void> login(String userName, BuildContext context) async {
  final model = Provider.of<GlobalModel>(context, listen: false);

  try {
    var result = await im.imLogin(userName, null);
    if (result.toString().contains('ucc')) {
      model.account = userName;
      model.goToLogin = false;
      await SharedUtil.saveString(SPKeys.account, userName);
      await SharedUtil.saveBoolean(SPKeys.hasLogged, true);
      model.refresh();
      await routePushAndRemove(new RootPage());
    } else {
      print('error::' + result.toString());
    }
  } on PlatformException {
    showToast('你已登录或者其他错误');
  }
}

Future<void> loginOut(BuildContext context) async {
  final model = Provider.of<GlobalModel>(context, listen: false);

  try {
    var result = await im.imLogout();
    if (result.toString().contains('ucc')) {
      showToast('登出成功');
    } else {
      print('error::' + result.toString());
    }
    model.goToLogin = true;
    model.refresh();
    await SharedUtil.saveBoolean(SPKeys.hasLogged, false);
    await routePushAndRemove(new LoginBeginPage());
  } on PlatformException {
    model.goToLogin = true;
    model.refresh();
    await SharedUtil.saveBoolean(SPKeys.hasLogged, false);
    await routePushAndRemove(new LoginBeginPage());
  }
}
