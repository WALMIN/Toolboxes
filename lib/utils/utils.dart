import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  // Default app bar
  static AppBar appBar = AppBar(
      toolbarHeight: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ));
}
