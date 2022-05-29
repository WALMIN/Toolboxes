import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/components/home/add_tool.dart';

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
  late var firebaseFirestore;

  ValueNotifier<bool> isSpeedDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser?.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Utils.appBar,
        backgroundColor: Palette.background,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: firebaseFirestore.snapshots(),
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

                      return Column(children: [
                        Column(
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
                            ]),
                      ]);
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ))),
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
