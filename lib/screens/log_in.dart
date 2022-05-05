import 'package:flutter/material.dart';

import '../utils/palette.dart';
import '../utils/utils.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Utils.appBar,
        backgroundColor: Palette.background,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 24, right: 24),
                child: Column(children: []))));
  }
}
