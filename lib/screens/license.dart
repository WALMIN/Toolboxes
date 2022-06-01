import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/license_util.dart';
import '../utils/palette.dart';
import '../utils/utils.dart';

class License extends StatelessWidget {
  final LicenseModel item;

  const License({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "${item.name} ${item.version?.replaceAll("^", "") ?? ""}",
                style: const TextStyle(color: Palette.onPrimary)),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Palette.primary,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            iconTheme: const IconThemeData(color: Palette.onPrimary)),
        backgroundColor: Palette.background,
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          item.homepage != null
              ? InkWell(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 24, right: 24),
                      child: Text(item.homepage ?? "n/a",
                          style:
                              const TextStyle(color: Colors.lightBlueAccent))),
                  onTap: () => Utils.openURL(item.homepage ?? "n/a", true))
              : Container(),
          item.repository != null
              ? InkWell(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 24, right: 24),
                      child: Text(item.repository ?? "n/a",
                          style:
                              const TextStyle(color: Colors.lightBlueAccent))),
                  onTap: () => Utils.openURL(item.repository ?? "n/a", true))
              : Container(),
          item.homepage != null || item.repository != null
              ? const Padding(
                  padding: EdgeInsets.only(top: 12, left: 24, right: 24),
                  child: Divider(color: Palette.onBackground, thickness: 1))
              : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
            child: Text(item.license,
                style: const TextStyle(color: Palette.onBackground)),
          ),
        ])));
  }
}
