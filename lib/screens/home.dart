import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/components/home/add_tool.dart';
import 'package:toolboxes/components/home/tool_item.dart';
import 'package:toolboxes/models/tool_model.dart';

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

  ValueNotifier<bool> isSpeedDialOpen = ValueNotifier(false);

  String currentStoragePlace = "all";

  List<String> storagePlaces = [];
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
    var data = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    for (var place in data["places"]) {
      storagePlaces.add(place);
    }

    storagePlaces.add(translate("home.all"));
    storagePlaces.sort((a, b) => (a).compareTo(b));
  }

  Future<void> fetchTools() async {
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .collection("tools")
        .get();
    for (var document in querySnapshot.docs) {
      tools.add(ToolModel(
          bought: document["bought"],
          boughtAt: document["bought_at"],
          name: document["name"],
          storagePlace: document["storage_place"],
          borrowed: document["borrowed"]));
    }

    tools.sort((a, b) => (a.name).compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Utils.appBar,
        backgroundColor: Palette.background,
        body: SafeArea(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(firebaseAuth.currentUser?.uid)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error loading, try again!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Palette.onBackground,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip));
            }

            if (snapshot.hasData) {
              Map<String, dynamic>? data = snapshot.data!.data()!;

              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(translate("home.welcome"),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Palette.onBackground, fontSize: 24)),
                          Text(data['firstName'],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Palette.onBackground,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                        ]),
                    tools.isNotEmpty
                        ? Column(children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                for (var place in storagePlaces)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Palette.background,
                                      onPrimary:
                                          (currentStoragePlace.toLowerCase() ==
                                                  place.toLowerCase())
                                              ? Palette.primary
                                              : Palette.onBackground,
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: (currentStoragePlace
                                                      .toLowerCase() ==
                                                  place.toLowerCase())
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        currentStoragePlace = place;
                                      });
                                    },
                                    child: Text(Utils.capitalize(place)),
                                  ),
                              ]),
                            ),
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              childAspectRatio: 8 / 5,
                              children: List.generate(
                                  (currentStoragePlace.toLowerCase() == "all")
                                      ? tools.length
                                      : tools
                                          .where((tool) => (tool.storagePlace
                                                  .toLowerCase() ==
                                              currentStoragePlace
                                                  .toLowerCase()))
                                          .length, (index) {
                                return ToolItem(toolModel: tools[index]);
                              }),
                            ),
                          ])
                        : const Center(child: CircularProgressIndicator())
                  ]);
            }

            return const Center(child: CircularProgressIndicator());
          },
        )),
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: const AddTool()));
                  },
                );
              })
        ]);
  }
}
