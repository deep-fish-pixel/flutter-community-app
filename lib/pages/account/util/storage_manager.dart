import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StorageManager {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  /// app全局配置
  static SharedPreferences? sp;

  /// 网络连接
  var connect;

  /// 必备数据的初始化操作
  static init() async {
    // async 异步操作
    // sync 同步操作
    sp = await _prefs;

    if (Platform.isAndroid) {
      StorageManager().initAutoLogin();
    } else {
      debugPrint('IOS自动登陆开发中');
    }
  }


  initAutoLogin() async {
    /*try {
      // 监测网络变化
      connect = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result != ConnectivityResult.mobile &&
            result != ConnectivityResult.wifi) {
          await SharedUtil.saveBoolean(Keys.brokenNetwork, true);
        } else {
          await SharedUtil.saveBoolean(Keys.brokenNetwork, false);
          final hasLogged =
          await SharedUtil.getBoolean(Keys.hasLogged);
          final currentUser = await im.getCurrentLoginUser();
          if (hasLogged) if (currentUser == '' || currentUser == null) {
            final account = await SharedUtil.getString(Keys.account);
            im.imAutoLogin(account);
          }
        }
      });
    } on PlatformException {
      print('你已登录或者其他错误');
    }*/
  }
}
