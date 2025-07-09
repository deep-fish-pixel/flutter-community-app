// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  /// app全局配置
  static SharedPreferences? sp;

  /// 网络连接

  /// 必备数据的初始化操作
  static init() async {
    // async 异步操作
    // sync 同步操作
    sp ??= await _prefs;
  }
}

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SharedPreferences Demo',
      home: SharedPreferencesDemo(),
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  const SharedPreferencesDemo({Key? key}) : super(key: key);

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late int _counter = 0;

  @override
  void activate() {
    StorageManager.init();
  }

  Future<void> _incrementCounter() async {
    final SharedPreferences? prefs = StorageManager.sp;
    print(prefs);
    final int counter = (prefs?.getInt('counter') ?? 0) + 1;


     prefs?.setInt('counter', counter).then((bool success) {
       setState(() {
         _counter =  counter;
       });
     });

  }



  @override
  void initState() {
    super.initState();
    StorageManager.init();
    setState(() {
      _counter = StorageManager.sp?.getInt('counter') ?? 0;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences Demo'),
      ),
      body: Center(
          child: Text(
        'Button tapped $_counter time${_counter == 1 ? '' : 's'}.\n\n'
        'This should persist across restarts.',
        )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}