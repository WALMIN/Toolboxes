import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/components/home/add_edit_tool.dart';
import 'package:toolboxes/models/tool_model.dart';
import 'package:toolboxes/screens/settings.dart';

import '../components/home/add_storage_place.dart';
import '../components/home/tool_item.dart';
import '../main.dart';
import '../utils/palette.dart';
import '../utils/utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firebaseFirestore;

  ValueNotifier<bool> isSpeedDialOpen = ValueNotifier(false);

  String currentStoragePlace = translate("home.all");

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
  }

  Future<void> removeStoragePlace(String id) async {
    String uid = firebaseAuth.currentUser?.uid ?? "";

    if (uid.isNotEmpty) {
      await firebaseFirestore
          .collection("users")
          .doc(uid)
          .collection("storage_places")
          .doc(id)
          .delete()
          .then((value) {
        Utils.showSnackBar(
            context, translate("delete_storage_place.successfully_deleted"));
      }).catchError((error) {
        Utils.showSnackBar(
            context, translate("delete_storage_place.failed_to_delete"));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Utils.appBar,
        backgroundColor: Palette.background,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: firebaseFirestore
                    .collection("users")
                    .doc(firebaseAuth.currentUser?.uid)
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic>? data = snapshot.data!.data()!;

                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 12, left: 24, right: 24),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(translate("home.welcome"),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Palette.onBackground,
                                            fontSize: 24)),
                                    Text(data["firstName"].toString(),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Palette.onBackground,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24)),
                                  ]),
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout,
                                  color: Palette.onBackground),
                              tooltip: translate("home.sign_out"),
                              onPressed: () {
                                Utils.showAlertDialog(
                                    context,
                                    translate("sign_out.title"),
                                    translate("sign_out.content"),
                                    translate("sign_out.negative_btn"),
                                    translate("sign_out.positive_btn"),
                                    () async {
                                  await firebaseAuth.signOut().then((result) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Main()),
                                        (route) => false);
                                  });
                                });
                              },
                            ),
                          ]),
                    );
                  }
                  return Container();
                },
              ),
              /*SizedBox(
                height: 48,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Palette.background,
                          onPrimary:
                              currentStoragePlace == translate("home.all")
                                  ? Palette.primary
                                  : Palette.onBackground,
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  currentStoragePlace == translate("home.all")
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                        ),
                        onPressed: () {
                          setState(() {
                            currentStoragePlace = translate("home.all");
                          });
                        },
                        child: Text(Utils.capitalize(translate("home.all"))),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: firebaseFirestore
                              .collection('users')
                              .doc(firebaseAuth.currentUser?.uid)
                              .collection("storage_places")
                              .orderBy("title", descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  return SizedBox(
                                    height: 48,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Palette.background,
                                        onPrimary: currentStoragePlace ==
                                                data["title"].toString()
                                            ? Palette.primary
                                            : Palette.onBackground,
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: currentStoragePlace ==
                                                    data["title"].toString()
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      ),
                                      onLongPress: () {
                                        Utils.showAlertDialog(
                                            context,
                                            translate(
                                                    "delete_storage_place.title")
                                                .replaceAll("[NAME]",
                                                    "\"${Utils.capitalize(data["title"])}\""),
                                            translate(
                                                "delete_storage_place.content"),
                                            translate(
                                                "delete_storage_place.negative_btn"),
                                            translate(
                                                "delete_storage_place.positive_btn"),
                                            () {
                                          removeStoragePlace(document.id);
                                        });
                                      },
                                      onPressed: () {
                                        setState(() {
                                          currentStoragePlace =
                                              data["title"].toString();
                                        });
                                      },
                                      child:
                                          Text(Utils.capitalize(data["title"])),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                            return Container();
                          }),
                    ],
                  ),
                ),
              ),*/
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: firebaseFirestore
                        .collection('users')
                        .doc(firebaseAuth.currentUser?.uid)
                        .collection("tools")
                        .orderBy("name", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.2,
                              left: 24,
                              right: 24),
                          child: Text(
                            translate("message.error_loading"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Palette.onBackground,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.clip),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.2,
                                left: 24,
                                right: 24),
                            child: Center(
                              child: Column(children: [
                                const Icon(
                                  Icons.handyman_outlined,
                                  color: Palette.onBackground,
                                  size: 64,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: Text(translate("home.no_tools"),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Palette.onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)))
                              ]),
                            ),
                          );
                        } else {
                          return GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 8 / 5,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;

                              ToolItem item = ToolItem(
                                  toolModel: ToolModel(
                                      id: document.id,
                                      name: data["name"],
                                      storagePlace: data["storage_place"],
                                      borrowedBy: data["borrowed_by"],
                                      borrowedAt: data["borrowed_at"],
                                      bought: data["bought"],
                                      boughtAt: data["bought_at"]));

                              return item;
                            }).toList(),
                          );
                        }
                      }

                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: floatingActionButton());
  }

  Widget floatingActionButton() {
    return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        openCloseDial: isSpeedDialOpen,
        backgroundColor: Palette.primary,
        foregroundColor: Palette.onPrimary,
        overlayColor: Colors.black12,
        overlayOpacity: 0.5,
        spacing: 2,
        spaceBetweenChildren: 2,
        closeManually: false,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.settings_outlined),
              label: translate("home.settings"),
              onTap: () {
                setState(() {
                  isSpeedDialOpen.value = false;
                });

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                    (route) => false);
              }),
          SpeedDialChild(
              child: const Icon(Icons.place_outlined),
              label: translate("home.add_storage_place"),
              onTap: () {
                setState(() {
                  isSpeedDialOpen.value = false;
                });

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: const AddStoragePlace()));
                  },
                );
              }),
          SpeedDialChild(
              child: const Icon(Icons.handyman_outlined),
              label: translate("home.add_tool"),
              onTap: () {
                setState(() {
                  isSpeedDialOpen.value = false;
                });

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddEditTool(
                            toolModel: ToolModel(
                                id: "",
                                name: "",
                                storagePlace: "",
                                borrowedBy: "",
                                borrowedAt: "",
                                bought: "",
                                boughtAt: ""),
                            edit: false),
                      ),
                    );
                  },
                );
              })
        ]);
  }
}
