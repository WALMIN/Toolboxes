import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../utils/palette.dart';
import '../../utils/utils.dart';
import '../default_button.dart';
import '../default_input.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  const ChangePassword({Key? key, required this.email}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late FirebaseAuth firebaseAuth;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      if (newPasswordEditingController.text ==
          confirmNewPasswordEditingController.text) {
        setState(() {
          showLoading = true;
        });
        reauthenticateUser();
      } else {
        showChangePasswordError(
            translate("edit_account.password_does_not_match"));
      }
    }
  }

  Future<void> reauthenticateUser() async {
    String uid = firebaseAuth.currentUser?.uid ?? "";

    if (uid.isNotEmpty) {
      try {
        await firebaseAuth.currentUser
            ?.reauthenticateWithCredential(EmailAuthProvider.credential(
                email: widget.email,
                password: currentPasswordEditingController.text))
            .then((value) {
          changePassword();
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showChangePasswordError(translate("edit_account.weak_password"));
        } else if (e.code == 'wrong-password') {
          showChangePasswordError(translate("edit_account.wrong_password"));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> changePassword() async {
    String uid = firebaseAuth.currentUser?.uid ?? "";

    if (uid.isNotEmpty) {
      try {
        await firebaseAuth.currentUser
            ?.updatePassword(newPasswordEditingController.text)
            .then((_) {
          Navigator.pop(context);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showChangePasswordError(translate("edit_account.weak_password"));
        } else if (e.code == 'wrong-password') {
          showChangePasswordError(translate("edit_account.wrong_password"));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void showChangePasswordError(String message) {
    setState(() {
      showLoading = false;
      showError = true;
      errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.surface,
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Text(translate("edit_account.change_password"),
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
                  required: true),
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
                  required: true),
              DefaultInput(
                  label: translate("edit_account.confirm_new_password"),
                  textEditingController: confirmNewPasswordEditingController,
                  initialValue: "",
                  obscureText: true,
                  textInputType: TextInputType.text,
                  formFieldType: FormFieldType.text,
                  onChanged: () {
                    setState(() {
                      showError = false;
                    });
                  },
                  required: true),
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
}
