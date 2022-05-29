import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/components/default_input.dart';
import 'package:toolboxes/screens/start.dart';

import '../components/default_button.dart';
import '../utils/palette.dart';
import '../utils/utils.dart';
import 'home.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool logInError = false;
  String logInErrorMessage = "";

  void validateForm() {
    if (formKey.currentState!.validate()) {
      logIn();
    }
  }

  Future<void> logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailEditingController.text,
          password: passwordEditingController.text);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        showLogInError(translate("log_in.no_user"));
      } else if (e.code == "wrong-password") {
        showLogInError(translate("log_in.wrong_password"));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showLogInError(String message) {
    setState(() {
      logInError = true;
      logInErrorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Start()),
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
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Palette.onBackground),
                                  iconSize: 32,
                                  tooltip: translate("log_in.go_back"),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Start()),
                                        (route) => false);
                                  },
                                )),
                            Container(
                                padding: const EdgeInsets.all(24),
                                child: Column(children: [
                                  Text(translate("log_in.title"),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          color: Palette.onBackground,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 48)),
                                  Container(
                                      padding: const EdgeInsets.only(top: 32),
                                      child: Form(
                                          key: formKey,
                                          child: Column(children: [
                                            DefaultInput(
                                                label:
                                                    translate("log_in.email"),
                                                textEditingController:
                                                    emailEditingController,
                                                obscureText: false,
                                                textInputType:
                                                    TextInputType.emailAddress,
                                                formFieldType:
                                                    FormFieldType.email,
                                                onChanged: () {}),
                                            DefaultInput(
                                                label: translate(
                                                    "log_in.password"),
                                                textEditingController:
                                                    passwordEditingController,
                                                obscureText: true,
                                                textInputType:
                                                    TextInputType.text,
                                                formFieldType:
                                                    FormFieldType.text,
                                                onChanged: () {}),
                                            if (logInError)
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16),
                                                  child: Text(logInErrorMessage,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Palette.error,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16))),
                                          ]))),
                                ]))
                          ]))),
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 32, left: 32, right: 32),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultButton(
                            title: translate("log_in.log_in"),
                            backgroundColor: Palette.primary,
                            textColor: Palette.onPrimary,
                            onPress: validateForm)
                      ]))
            ]))));
  }
}
