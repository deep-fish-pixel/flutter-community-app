import 'package:flutter/cupertino.dart';

class KeyValue {
  final String key;
  final String value;
  bool checked;
  Icon? icon;

  KeyValue({
    required this.key,
    required this.value,
    this.checked = false,
    this.icon,
  });
}