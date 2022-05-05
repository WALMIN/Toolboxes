import 'package:flutter/material.dart';

import '../utils/palette.dart';
import '../utils/utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Utils.appBar,
        backgroundColor: Palette.background,
        body: SafeArea(child: Column(children: [])));
  }
}
