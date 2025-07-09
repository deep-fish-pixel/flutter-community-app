import 'package:shared_preferences/shared_preferences.dart';

import '../pages/account/util/sp_keys.dart';

class SharedUtil {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static late final SharedPreferences sp;

  static Future<SharedPreferences> initSP() async {
    sp = await _prefs;
    return sp;
  }

  /// 必备数据的初始化操作
  static Future<SharedPreferences> getSP() async {
    SharedPreferences sp = await _prefs;
    return sp;
  }

  /// save
  static Future saveString(String key, String value) async {
    if (key == SPKeys.account) {
      await sp.setString(key, value);
      return;
    }
    String account = sp.getString(SPKeys.account) ?? "default";
    await sp.setString(key + account, value);
  }

  static Future saveInt(String key, int value) async {
    String account = sp.getString(SPKeys.account) ?? "default";
    await sp.setInt(key + account, value);
  }

  static Future saveDouble(String key, double value) async {
    String account = sp.getString(SPKeys.account) ?? "default";
    await sp.setDouble(key + account, value);
  }

  static Future saveBoolean(String key, bool value) async {
    String account = sp.getString(SPKeys.account) ?? "default";
    await sp.setBool(key + account, value);
  }

  static Future saveStringList(String key, List<String> list) async {
    String account = sp.getString(SPKeys.account) ?? "default";
    await sp.setStringList(key + account, list);
  }

  static Future<bool> readAndSaveList(String key, String data) async {
    String account = sp.getString(SPKeys.account) ?? "default";
    List<String> strings = sp.getStringList(key + account) ?? [];
    if (strings.length >= 10) return false;
    strings.add(data);
    await sp.setStringList(key + account, strings);
    return true;
  }

  static Future readAndExchangeList(String key, String data, int index) async {
    String account = sp.getString(SPKeys.account) ?? "default";
    List<String> strings = sp.getStringList(key + account) ?? [];
    strings[index] = data;
    await sp.setStringList(key + account, strings);
  }

  static Future readAndRemoveList(String key, int index) async {
    String account = sp.getString(SPKeys.account) ?? "default";
    List<String> strings = sp.getStringList(key + account) ?? [];
    strings.removeAt(index);
    await sp.setStringList(key + account, strings);
  }

  /// get
  static String? getString(String key) {
    DateTime dt = DateTime.now();
    print('StorageManager.sp');
    print(DateTime.now().difference(dt));
    if (key == SPKeys.account) {
      return sp.getString(key);
    }
    String account = sp.getString(SPKeys.account) ?? "default";
    return sp.getString(key + account);
  }

  static int? getInt(String key) {
    String account = sp.getString(SPKeys.account) ?? "default";
    return sp.getInt(key + account);
  }

  static double? getDouble(String key) {
    String account = sp.getString(SPKeys.account) ?? "default";
    return sp.getDouble(key + account);
  }

  static bool? getBoolean(String key) {
    String account = sp.getString(SPKeys.account) ?? "default";
    return sp.getBool(key + account);
  }

  static List<String> getStringList(String key) {
    String account = sp.getString(SPKeys.account) ?? "default";
    return sp.getStringList(key + account) ?? [];
  }

  static List<String> readList(String key) {
    String account = sp.getString(SPKeys.account) ?? "default";
    List<String> strings = sp.getStringList(key + account) ?? [];
    return strings;
  }
}
