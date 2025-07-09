import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/pages/account/util/sp_keys.dart';

class GlobalModel extends ChangeNotifier {
  ///app的名字
  String appName = "gardener";

  /// 用户信息
  String account = '';
  String nickName = 'nickName';
  String avatar = '';
  int gender = 0;

  ///是否进入登录页
  bool goToLogin = true;

  ///选择社区
  String? community;



  void initInfo() async {
    // final data = await getUsersProfile([account]);
    final data = '';
    if (data == null) return;
    List<dynamic> result = json.decode(data);
    if (Platform.isAndroid) {
      nickName = result[0]['nickName'];
      avatar = result[0]['faceUrl'];
      await saveUserInfo();
      gender = result[0]['gender'];
      await SharedUtil.saveInt(SPKeys.gender, result[0]['gender']);
    } else {
      /*IPersonInfoEntity model = IPersonInfoEntity.fromJson(result[0]);
      nickName = model.nickname;
      await SharedUtil.saveString(SPKeys.nickName, model.nickname);
      avatar = model.faceURL;
      await SharedUtil.saveString(SPKeys.faceUrl, model.faceURL);
      gender = model.gender;
      await SharedUtil.saveInt(SPKeys.gender, model.gender);*/
    }
  }

  Future<void> setContext(BuildContext context, { bool notify = true }) async {
    String? avatar = SharedUtil.getString(SPKeys.avatar);
    String? nickName = SharedUtil.getString(SPKeys.nickName);
    if (avatar != null) {
      this.avatar = avatar;
    }
    if (nickName != null) {
      this.nickName = nickName;
    }

    bool? hasLogin = SharedUtil.getBoolean(SPKeys.hasLogin);
    if (hasLogin == null) {
      if (goToLogin == false) {
        goToLogin = true;
        if (notify) {
          notifyListeners();
        }
      }
    } else if (goToLogin != hasLogin) {
      goToLogin = hasLogin;
      if (notify) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("GlobalModel销毁了");
  }

  void refresh() {
    if (!goToLogin) initInfo();
    notifyListeners();
  }

  void setLogin() {
    goToLogin = false;
  }

  Future<void> saveUserInfo() async {
    await SharedUtil
        .saveString(SPKeys.nickName, nickName);
    await SharedUtil.saveString(SPKeys.avatar, avatar);
    await SharedUtil.saveBoolean(SPKeys.hasLogin, true);
    notifyListeners();
  }

  Future<void> setCommunity(String community) async {
    this.community = community;
    await SharedUtil.saveString(SPKeys.community, community);
  }

  String getCommunity() {
    if (community == null) {
      String? community = SharedUtil.getString(SPKeys.community);
      this.community = community ?? '';
    }

    return this.community ?? '';
  }
}
