import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/models/tool_model.dart';

import '../../utils/palette.dart';
import '../../utils/utils.dart';
import '../default_button.dart';
import '../default_input.dart';

class AddEditTool extends StatefulWidget {
  final ToolModel toolModel;
  final bool edit;

  const AddEditTool({Key? key, required this.toolModel, required this.edit})
      : super(key: key);

  @override
  State<AddEditTool> createState() => _AddEditToolState();
}

class _AddEditToolState extends State<AddEditTool> {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firebaseFirestore;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController boughtAtEditingController = TextEditingController();
  TextEditingController boughtEditingController = TextEditingController();
  TextEditingController placeEditingController = TextEditingController();
  TextEditingController borrowedByEditingController = TextEditingController();
  TextEditingController borrowedAtEditingController = TextEditingController();

  bool placeError = false;

  DateTime currentDateTime = DateTime.now();

  bool showLoading = false;
  bool showError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;

    nameEditingController.text = widget.toolModel.name;
    boughtAtEditingController.text = widget.toolModel.boughtAt;
    boughtEditingController.text = widget.toolModel.bought;
    placeEditingController.text = widget.toolModel.storagePlace;
    borrowedByEditingController.text = widget.toolModel.borrowedBy;
    borrowedByEditingController.text = widget.toolModel.borrowedBy;
    borrowedAtEditingController.text = widget.toolModel.borrowedAt;

    setState(() {});
  }

  void validateForm() {
    setState(() {
      placeError = placeEditingController.text.isNotEmpty ? false : true;
    });

    if (formKey.currentState!.validate() &&
        placeEditingController.text.isNotEmpty) {
      setState(() {
        showLoading = true;
      });
      addEditTool();
    }
  }

  Future<void> addEditTool() async {
    String uid = firebaseAuth.currentUser?.uid ?? "";

    if (uid.isNotEmpty) {
      final tool = {
        "name": nameEditingController.text,
        "storage_place": placeEditingController.text,
        "borrowed_by": borrowedByEditingController.text,
        "borrowed_at": borrowedAtEditingController.text,
        "bought_at": boughtAtEditingController.text,
        "bought": boughtEditingController.text
      };

      if (widget.edit) {
        await firebaseFirestore
            .collection("users")
            .doc(uid)
            .collection("tools")
            .doc(widget.toolModel.id)
            .update(tool)
            .then((value) {
          Navigator.pop(context);
          Utils.showSnackBar(
              context, translate("add_edit_tool.successfully_updated"));
        }).catchError((error) {
          setState(() {
            showLoading = false;
            showError = true;
            errorMessage = translate("add_edit_tool.failed_to_update");
          });
        });
      } else {
        await firebaseFirestore
            .collection("users")
            .doc(uid)
            .collection("tools")
            .add(tool)
            .then((value) {
          Navigator.pop(context);
          Utils.showSnackBar(
              context, translate("add_edit_tool.successfully_added"));
        }).catchError((error) {
          setState(() {
            showLoading = false;
            showError = true;
            errorMessage = translate("add_edit_tool.failed_to_add");
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser?.uid)
          .collection("storage_places")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return Container(
            color: Palette.surface,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text(
                  translate(widget.edit
                      ? "add_edit_tool.edit_tool"
                      : "add_edit_tool.add_tool"),
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
                        label: translate("add_edit_tool.name"),
                        textEditingController: nameEditingController,
                        initialValue: widget.toolModel.name,
                        obscureText: false,
                        textInputType: TextInputType.text,
                        formFieldType: FormFieldType.text,
                        onChanged: () {
                          setState(() {
                            showError = false;
                          });
                        },
                        required: true),
                    DefaultInput(
                        label: translate("add_edit_tool.bought_at"),
                        textEditingController: boughtAtEditingController,
                        initialValue: widget.toolModel.boughtAt,
                        obscureText: false,
                        textInputType: TextInputType.text,
                        formFieldType: FormFieldType.text,
                        onChanged: () {
                          setState(() {
                            showError = false;
                          });
                        },
                        required: true),
                    Stack(children: [
                      GestureDetector(
                        onTap: () async {
                          boughtEditingController.text =
                              await Utils.showDatePickerDialog(
                                  context, currentDateTime);
                          setState(() {});
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
                                errorStyle:
                                    const TextStyle(color: Palette.error),
                                errorBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Palette.error)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Palette.error)),
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
                                labelText: translate("add_edit_tool.bought")),
                          ),
                        )),
                      ),
                      boughtEditingController.text.isNotEmpty
                          ? Positioned(
                              top: 0,
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.clear,
                                    color: Palette.onSurface),
                                onPressed: () {
                                  setState(() {
                                    boughtEditingController.clear();
                                  });
                                },
                              ),
                            )
                          : Container()
                    ]),
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
                                      ? translate("add_edit_tool.storage_place")
                                      : placeEditingController.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Palette.onSurface,
                                  )),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Palette.onSurface,
                              ),
                              items: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;

                                return DropdownMenuItem<String>(
                                  value: data["title"],
                                  child: Row(
                                    children: [
                                      Text(data["title"]),
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
                    widget.edit
                        ? DefaultInput(
                            label: translate("add_edit_tool.borrowed_by"),
                            textEditingController: borrowedByEditingController,
                            initialValue: widget.toolModel.borrowedBy,
                            obscureText: false,
                            textInputType: TextInputType.text,
                            formFieldType: FormFieldType.text,
                            onChanged: () {
                              setState(() {
                                showError = false;
                              });
                            },
                            required: false)
                        : Container(),
                    widget.edit
                        ? Stack(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  borrowedAtEditingController.text =
                                      await Utils.showDatePickerDialog(
                                          context, currentDateTime);
                                  setState(() {});
                                },
                                child: AbsorbPointer(
                                    child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12),
                                  child: TextFormField(
                                    maxLines: 1,
                                    validator: (value) {
                                      return Utils.validateField(
                                          false, value, FormFieldType.date);
                                    },
                                    controller: borrowedAtEditingController,
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
                                        errorStyle: const TextStyle(
                                            color: Palette.error),
                                        errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.error)),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Palette.error)),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.onSurface)),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.onSurface)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.onSurface)),
                                        labelStyle: const TextStyle(
                                          color: Palette.onSurface,
                                        ),
                                        labelText: translate(
                                            "add_edit_tool.borrowed_at")),
                                  ),
                                )),
                              ),
                              borrowedAtEditingController.text.isNotEmpty
                                  ? Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Palette.onSurface),
                                        onPressed: () {
                                          setState(() {
                                            borrowedAtEditingController.clear();
                                          });
                                        },
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        : Container(),
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
                                    title: translate(widget.edit
                                        ? "add_edit_tool.save"
                                        : "add_edit_tool.add"),
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
