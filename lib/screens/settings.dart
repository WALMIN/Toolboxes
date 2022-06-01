import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../components/settings/edit_account.dart';
import '../models/settings_model.dart';
import '../utils/palette.dart';
import '../utils/utils.dart';
import 'home.dart';
import 'licenses.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<SettingsModel> aboutList = [];

  @override
  void initState() {
    super.initState();

    aboutList = [
      SettingsModel(
          icon: Icons.article_outlined,
          title: translate("settings.licenses"),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Licenses()));
          }),
      SettingsModel(
          icon: Icons.description_outlined,
          title: translate("settings.privacy_policy"),
          onTap: () {
            Utils.openURL(
                "https://walmin.com/toolboxes/privacypolicy.html", false);
          })
    ];
    aboutList.sort((a, b) => (a.title).compareTo(b.title));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: Utils.appBar,
        backgroundColor: Palette.background,
        body: SafeArea(
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Palette.onBackground),
                            iconSize: 32,
                            tooltip: translate("settings.go_back"),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()),
                                  (route) => false);
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(translate("settings.title"),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Palette.onBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 48)),
                                Padding(
                                    padding: const EdgeInsets.only(top: 32),
                                    child: Text(translate("settings.general"),
                                        style: const TextStyle(
                                            color: Palette.onBackground,
                                            fontWeight: FontWeight.bold))),
                                ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: const Icon(
                                        Icons.account_circle_outlined,
                                        color: Palette.onBackground),
                                    title: Text(
                                        translate("settings.edit_account"),
                                        style: const TextStyle(
                                            color: Palette.onBackground)),
                                    trailing: const Icon(Icons.navigate_next,
                                        color: Palette.onPrimary),
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return SingleChildScrollView(
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: const EditAccount()));
                                        },
                                      );
                                    }),
                                const SizedBox(height: 12),
                                Text(translate("settings.about"),
                                    style: const TextStyle(
                                        color: Palette.onBackground,
                                        fontWeight: FontWeight.bold)),
                                for (var aboutItem in aboutList)
                                  settingsItem(aboutItem.icon, aboutItem.title,
                                      aboutItem.onTap),
                              ])),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

Widget settingsItem(IconData icon, String title, Function onTap) {
  return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Icon(icon, color: Palette.onBackground),
      title: Text(title, style: const TextStyle(color: Palette.onBackground)),
      trailing: const Icon(Icons.navigate_next, color: Palette.onPrimary),
      onTap: () {
        onTap();
      });
}
