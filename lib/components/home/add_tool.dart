import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../utils/palette.dart';
import '../../utils/utils.dart';
import '../default_button.dart';
import '../default_input.dart';

class AddTool extends StatefulWidget {
  const AddTool({Key? key}) : super(key: key);

  @override
  State<AddTool> createState() => _AddToolState();
}

class _AddToolState extends State<AddTool> {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firebaseFirestore;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController boughtAtEditingController = TextEditingController();
  TextEditingController boughtEditingController = TextEditingController();
  TextEditingController placeEditingController = TextEditingController();

  bool place = false;
  bool placeError = false;

  DateTime boughtDate = DateTime.now();

  bool showLoading = false;
  bool showError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
  }

  void validateForm() {
    if (formKey.currentState!.validate() && place) {
      addTool();
    }

    setState(() {
      placeError = placeEditingController.text.isNotEmpty ? false : true;
    });
  }

  void addTool() {
    String uid = firebaseAuth.currentUser?.uid ?? "";

    if (uid.isNotEmpty) {
      final tool = <String, dynamic>{
        "name": nameEditingController.text,
        "bought_at": boughtAtEditingController.text,
        "bought": boughtEditingController.text,
        "storage_place": placeEditingController.text
      };
      firebaseFirestore
          .collection("users")
          .doc(uid)
          .collection("tools")
          .add(tool)
          .then((value) {
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
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: firebaseFirestore
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

          return Container(
            color: Palette.surface,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text(translate("add_tool.title"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Palette.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Container(
                padding: const EdgeInsets.only(top: 8, left: 6, right: 6),
                child: Form(
                  key: formKey,
                  child: Column(children: [
                    DefaultInput(
                        label: translate("add_tool.name"),
                        textEditingController: nameEditingController,
                        obscureText: false,
                        textInputType: TextInputType.text,
                        formFieldType: FormFieldType.text,
                        onChanged: () {
                          setState(() {
                            showError = false;
                          });
                        }),
                    DefaultInput(
                        label: translate("add_tool.bought_at"),
                        textEditingController: boughtAtEditingController,
                        obscureText: false,
                        textInputType: TextInputType.text,
                        formFieldType: FormFieldType.text,
                        onChanged: () {
                          setState(() {
                            showError = false;
                          });
                        }),
                    GestureDetector(
                      onTap: () async => {
                        boughtEditingController.text =
                            await Utils.showDatePickerDialog(
                                context, boughtDate)
                      },
                      child: AbsorbPointer(
                          child: Container(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            return Utils.validateField(
                                true, value, FormFieldType.date);
                          },
                          controller: boughtEditingController,
                          keyboardType: TextInputType.datetime,
                          style: const TextStyle(
                            color: Palette.onSurface,
                          ),
                          onChanged: (value) {
                            setState(() {
                              showError = false;
                            });
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              isDense: true,
                              errorStyle: const TextStyle(color: Palette.error),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Palette.error)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Palette.error)),
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palette.onSurface)),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palette.onSurface)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palette.onSurface)),
                              labelStyle: const TextStyle(
                                color: Palette.onSurface,
                              ),
                              labelText: translate("add_tool.bought")),
                        ),
                      )),
                    ),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              isDense: true,
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: placeError
                                          ? Palette.error
                                          : Palette.onSurface)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: placeError
                                          ? Palette.error
                                          : Palette.onSurface)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: placeError
                                          ? Palette.error
                                          : Palette.onSurface)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: placeError
                                          ? Palette.error
                                          : Palette.onSurface)),
                              labelStyle: const TextStyle(
                                color: Palette.onSurface,
                              )),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Palette.surface,
                              icon: const Icon(
                                Icons.expand_more,
                                color: Palette.onSurface,
                              ),
                              hint: Text(
                                  placeEditingController.text.isEmpty
                                      ? translate("add_tool.storage_place")
                                      : placeEditingController.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Palette.onSurface,
                                  )),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Palette.onSurface,
                              ),
                              items: (data['places'] as List)
                                  .map((item) => item as String)
                                  .toList()
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Text(value),
                                    ],
                                  ),
                                );
                              }).toList(),
                              isExpanded: true,
                              isDense: true,
                              onChanged: (value) {
                                setState(() {
                                  placeEditingController.text = value ?? "";
                                  if ((value ?? "").isNotEmpty) {
                                    place = true;
                                    placeError = false;

                                    showError = false;
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
                ),
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
                                    title: translate("add_tool.add"),
                                    backgroundColor: Palette.primary,
                                    textColor: Palette.onPrimary,
                                    onPress: validateForm)
                              ]),
              ),
            ]),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
