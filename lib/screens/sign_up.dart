import 'package:flutter/material.dart';

import '../utils/palette.dart';
import '../utils/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
