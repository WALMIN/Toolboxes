import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/components/default_input.dart';

import '../../utils/palette.dart';
import '../../utils/utils.dart';
import '../default_button.dart';

class AddStoragePlace extends StatefulWidget {
  const AddStoragePlace({Key? key}) : super(key: key);

  @override
  State<AddStoragePlace> createState() => _AddStoragePlaceState();
}

class _AddStoragePlaceState extends State<AddStoragePlace> {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firebaseFirestore;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController placeEditingController = TextEditingController();

  List<String> places = [];

  bool showLoading = false;
  bool showError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;

    getPlaces();
  }

  void getPlaces() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    Map<String, dynamic> data = docSnapshot.data()!;

    setState(() {
      places = (data['places'] as List).map((item) => item as String).toList();
      debugPrint(places.toString());
    });
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      setState(() {
        showLoading = true;
      });
      addPlace();
    }
  }

  void addPlace() {
    String uid = firebaseAuth.currentUser?.uid ?? "";

    if (uid.isNotEmpty) {
      places.add(placeEditingController.text);

      firebaseFirestore.collection("users").doc(uid).update({
        "places": places,
      }).then((value) {
        Navigator.pop(context);
        Utils.showSnackBar(
            context, translate("add_storage_place.successfully_added"));
      }).catchError((error) {
        setState(() {
          showLoading = false;

          showError = true;
          errorMessage = translate("add_storage_place.failed_to_add");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Palette.surface,
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text(translate("add_storage_place.title"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Palette.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          Container(
            padding: const EdgeInsets.only(top: 8, left: 6, right: 6),
            child: Form(
                key: formKey,
                child: DefaultInput(
                    label: translate("add_storage_place.place"),
                    textEditingController: placeEditingController,
                    obscureText: false,
                    textInputType: TextInputType.text,
                    formFieldType: FormFieldType.text,
                    onChanged: () {
                      setState(() {
                        showError = false;
                      });
                    })),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 32),
              child: showError
                  ? SizedBox(
                      height: 54,
                      child: Center(
                          child: Text(errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Palette.error,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16))))
                  : showLoading
                      ? const SizedBox(
                          width: 54,
                          height: 54,
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator()))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              DefaultButton(
                                  title: translate("add_storage_place.add"),
                                  backgroundColor: Palette.primary,
                                  textColor: Palette.onPrimary,
                                  onPress: validateForm)
                            ]))
        ]));
  }
}
