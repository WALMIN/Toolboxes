import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../screens/license.dart';
import '../utils/license_util.dart';
import '../utils/palette.dart';

class Licenses extends StatefulWidget {
  const Licenses({Key? key}) : super(key: key);

  @override
  State<Licenses> createState() => _LicensesState();
}

class _LicensesState extends State<Licenses> {
  List<LicenseModel> licenseList = [];

  @override
  void initState() {
    super.initState();

    licenseList = LicenseUtil.getLicenses();
    licenseList.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(translate("settings.licenses"),
                style: const TextStyle(color: Palette.onPrimary)),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Palette.primary,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            iconTheme: const IconThemeData(color: Palette.onPrimary)),
        backgroundColor: Palette.background,
        body: licenseList.isNotEmpty
            ? ListView.builder(
                itemCount: licenseList.length,
                itemBuilder: (context, index) {
                  final item = licenseList[index];
                  return ListTile(
                      title: Text(
                          "${item.name} ${item.version?.replaceAll("^", "") ?? ""}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Palette.onBackground)),
                      trailing: const Icon(Icons.chevron_right,
                          color: Palette.onBackground),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => License(item: item))));
                },
              )
            : const Center(
                child: CircularProgressIndicator(color: Palette.onBackground)));
  }
}
