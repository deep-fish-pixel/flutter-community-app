import 'package:flutter/material.dart';

class EasyViewerChild {
  final Widget Function(BuildContext context) buildChild;

  EasyViewerChild(
      {
        required this.buildChild
      }
      );
}