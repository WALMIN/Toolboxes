import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/components/default_button.dart';

import '../utils/palette.dart';
import '../utils/utils.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  void logIn() {}

  void singUp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Utils.appBar,
        backgroundColor: Palette.background,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 24, right: 24),
                child: Column(children: [
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        const Icon(
                          Icons.handyman_outlined,
                          color: Palette.onBackground,
                          size: 96,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Text(translate("start.title"),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Palette.onBackground,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32))),
                      ])),
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultButton(
                                title: translate("start.log_in"),
                                backgroundColor: Palette.primary,
                                textColor: Palette.onPrimary,
                                onPress: logIn),
                            DefaultButton(
                                title: translate("start.sign_up"),
                                backgroundColor: Palette.primary,
                                textColor: Palette.onPrimary,
                                onPress: singUp)
                          ]))
                ]))));
  }
}
