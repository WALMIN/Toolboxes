import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../utils/palette.dart';
import '../../utils/utils.dart';
import '../default_button.dart';
import '../default_input.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firebaseFirestore;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController currentPasswordEditingController =
      TextEditingController();
  TextEditingController newPasswordEditingController = TextEditingController();
  TextEditingController confirmNewPasswordEditingController =
      TextEditingController();

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
    if (formKey.currentState!.validate()) {
      updateAccount();
    }
  }

  Future<void> updateAccount() async {
    String uid = firebaseAuth.currentUser?.uid ?? "";

    debugPrint("Name: " + firstNameEditingController.text);

    if (uid.isNotEmpty) {
      await firebaseFirestore.collection("users").doc(uid).update({
        "firstName": firstNameEditingController.text,
        "email": emailEditingController.text
      }).then((value) {
        Navigator.pop(context);
        Utils.showSnackBar(
            context, translate("edit_account.successfully_updated"));
      }).catchError((error) {
        setState(() {
          showLoading = false;

          showError = true;
          errorMessage = translate("edit_account.failed_to_update");
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

          return Container(
            color: Palette.surface,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text(translate("edit_account.title"),
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
                        label: translate("edit_account.first_name"),
                        textEditingController: firstNameEditingController,
                        initialValue: data["firstName"],
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
                        label: translate("edit_account.email"),
                        textEditingController: emailEditingController,
                        initialValue: data["email"],
                        obscureText: false,
                        textInputType: TextInputType.emailAddress,
                        formFieldType: FormFieldType.email,
                        onChanged: () {
                          setState(() {
                            showError = false;
                          });
                        },
                        required: true),
                    DefaultInput(
                        label: translate("edit_account.current_password"),
                        textEditingController: currentPasswordEditingController,
                        initialValue: "",
                        obscureText: true,
                        textInputType: TextInputType.text,
                        formFieldType: FormFieldType.text,
                        onChanged: () {
                          setState(() {
                            showError = false;
                          });
                        },
                        required: false),
                    DefaultInput(
                        label: translate("edit_account.new_password"),
                        textEditingController: newPasswordEditingController,
                        initialValue: "",
                        obscureText: true,
                        textInputType: TextInputType.text,
                        formFieldType: FormFieldType.text,
                        onChanged: () {
                          setState(() {
                            showError = false;
                          });
                        },
                        required: false),
                    DefaultInput(
                        label: translate("edit_account.confirm_new_password"),
                        textEditingController:
                            confirmNewPasswordEditingController,
                        initialValue: "",
                        obscureText: true,
                        textInputType: TextInputType.text,
                        formFieldType: FormFieldType.text,
                        onChanged: () {
                          setState(() {
                            showError = false;
                          });
                        },
                        required: false),
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
                                    title: translate("edit_account.save"),
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
