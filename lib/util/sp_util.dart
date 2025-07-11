import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

/**
 * @Author: thl
 * @GitHub: https://github.com/Sky24n
 * @Email: 863764940@qq.com
 * @Email: sky24no@gmail.com
 * @Date: 2018/9/8
 * @Description: Sp Util.
 */

/// SharedPreferences Util.
class SpUtil {
  static SpUtil _singleton = SpUtil._();
  static SharedPreferences? _prefs;
  static Lock _lock = Lock();

  static Future<SpUtil> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          // 保持本地实例直到完全初始化。
          var singleton = SpUtil._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  SpUtil._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool>? putObject(String key, Object value) {
    if (_prefs == null) return Future(() => false);
    return _prefs?.setString(key, value == null ? "" : json.encode(value));
  }

  /// get object.
  static Map? getObject(String key) {
    if (_prefs == null) return null;
    String? _data = _prefs?.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }


  /// get object.
  static Object? getObject2(String key) {
    if (_prefs == null) return null;
    String? _data = _prefs?.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  static Future<bool>? putObjectList(String key, List<Object> list) {
    if (_prefs == null) return Future(() => false);
    List<String>? _dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return _prefs?.setStringList(key, _dataList);
  }

  /// get object list.
  static List<Map>? getObjectList(String key) {
    if (_prefs == null) return null;
    List<String>? dataLis = _prefs?.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  /// get string.
  static String getString(String key, {String defValue = ''}) {
    if (_prefs == null) return defValue;
    return _prefs?.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool>? putString(String key, String value) {
    if (_prefs == null) return Future(() => false);
    return _prefs?.setString(key, value);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) return defValue;
    return _prefs?.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool>? putBool(String key, bool value) {
    if (_prefs == null) return Future(() => false);
    return _prefs?.setBool(key, value);
  }

  /// get int.
  static int getInt(String key, {int defValue = 0}) {
    if (_prefs == null) return defValue;
    return _prefs?.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool>? putInt(String key, int value) {
    if (_prefs == null) return Future(() => false);
    return _prefs?.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key,  double defValue  ) {
    if (_prefs == null) return defValue;
    return _prefs?.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool>? putDouble(String key, double value) {
    if (_prefs == null) return Future(() => false);
    return _prefs?.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_prefs == null) return defValue;
    return _prefs?.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool>? putStringList(String key, List<String> value) {
    if (_prefs == null) return Future(() => false);
    return _prefs?.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {required Object defValue}) {
    if (_prefs == null) return defValue;
    return _prefs?.get(key) ?? defValue;
  }

  /// have key.
  static bool? haveKey(String key) {
    if (_prefs == null) return false;
    return _prefs?.getKeys().contains(key);
  }

  /// get keys.
  static Set<String>? getKeys() {
    if (_prefs == null) return Set();
    return _prefs?.getKeys();
  }

  /// remove.
  static Future<bool>? remove(String key) {
    if (_prefs == null) return Future(() => false);
    return _prefs?.remove(key);
  }

  /// clear.
  static Future<bool>? clear() {
    if (_prefs == null) return Future(() => false);
    return _prefs?.clear();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _prefs != null;
  }











}