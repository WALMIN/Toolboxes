import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/components/home/add_edit_tool.dart';
import 'package:toolboxes/components/home/tool_item.dart';
import 'package:toolboxes/models/tool_model.dart';
import 'package:toolboxes/screens/settings.dart';

import '../components/home/add_storage_place.dart';
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

  bool loading = false;

  ValueNotifier<bool> isSpeedDialOpen = ValueNotifier(false);

  int currentStoragePlace = 0;

  List<String> storagePlaces = [];
  List<ToolModel> allTools = [];
  List<ToolModel> tools = [];

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;

    fetchStoragePlace();
    fetchTools();
  }

  Future<void> fetchStoragePlace() async {
    storagePlaces.clear();

    var data = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    for (var place in data["places"]) {
      storagePlaces.add(place);
    }

    storagePlaces.add(translate("home.all"));
    storagePlaces.sort((a, b) => (a).compareTo(b));

    setState(() {});
  }

  Future<void> fetchTools() async {
    loading = true;
    tools.clear();

    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .collection("tools")
        .get();
    for (var document in querySnapshot.docs) {
      tools.add(
        ToolModel(
            id: document.id,
            name: document["name"],
            storagePlace: document["storage_place"],
            borrowedBy: document["borrowed_by"],
            borrowedAt: document["borrowed_at"],
            bought: document["bought"],
            boughtAt: document["bought_at"]),
      );

      loading = false;
    }

    tools.sort((a, b) => (a.name).compareTo(b.name));

    allTools = tools;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Utils.appBar,
        backgroundColor: Palette.background,
        body: SafeArea(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: firebaseFirestore
                .collection("users")
                .doc(firebaseAuth.currentUser?.uid)
                .snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Text(translate("message.error_loading"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Palette.onBackground,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip));
              }

              if (snapshot.hasData) {
                Map<String, dynamic>? data = snapshot.data!.data()!;

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 24, bottom: 18, left: 24, right: 24),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(translate("home.welcome"),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Palette.onBackground,
                                        fontSize: 24)),
                                Text(data['firstName'],
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Palette.onBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                              ])),
                      Column(children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            for (var i = 0; i < storagePlaces.length; i++)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Palette.background,
                                  onPrimary: currentStoragePlace == i
                                      ? Palette.primary
                                      : Palette.onBackground,
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: currentStoragePlace == i
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                                onPressed: () {
                                  setState(() {
                                    currentStoragePlace = i;

                                    if (i > 0) {
                                      tools = allTools
                                          .where((tool) =>
                                              tool.storagePlace.toLowerCase() ==
                                              storagePlaces[i].toLowerCase())
                                          .toList();
                                    } else {
                                      tools = allTools.toList();
                                    }
                                  });
                                },
                                child: Text(Utils.capitalize(storagePlaces[i])),
                              ),
                          ]),
                        ),
                        Expanded(
                          child: loading
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.2),
                                  child: const Center(
                                      child: CircularProgressIndicator()))
                              : (tools.isNotEmpty && allTools.isNotEmpty)
                                  ? GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      childAspectRatio: 8 / 5,
                                      children:
                                          List.generate(tools.length, (index) {
                                        return ToolItem(
                                            toolModel: tools[index],
                                            completed: () {
                                              fetchTools();
                                            });
                                      }),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          left: 12,
                                          right: 12),
                                      child: Center(
                                        child: Column(children: [
                                          const Icon(
                                            Icons.handyman_outlined,
                                            color: Palette.onBackground,
                                            size: 96,
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 32),
                                              child: Text(
                                                  translate("home.no_tools"),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Palette.onSurface,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)))
                                        ]),
                                      ),
                                    ),
                        ),
                      ]),
                    ]);
              }
              return Container();
            },
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
                            child: AddStoragePlace(completed: () {
                              fetchStoragePlace();
                            })));
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddEditTool(
                                toolModel: ToolModel(
                                    id: "",
                                    name: "",
                                    storagePlace: "",
                                    borrowedBy: "",
                                    borrowedAt: "",
                                    bought: "",
                                    boughtAt: ""),
                                edit: false,
                                completed: () {
                                  fetchTools();
                                })));
                  },
                );
              })
        ]);
  }
}
