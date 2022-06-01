import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/screens/start.dart';

import '../components/default_button.dart';
import '../components/default_input.dart';
import '../utils/palette.dart';
import '../utils/utils.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firebaseFirestore;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController =
      TextEditingController();

  bool termsPrivacy = false;
  bool termsPrivacyError = false;

  bool signUpError = false;
  String signUpErrorMessage = "";

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
  }

  void validateForm() {
    if (formKey.currentState!.validate() && termsPrivacy) {
      if (passwordEditingController.text ==
          confirmPasswordEditingController.text) {
        signUp();
      } else {
        showSignUpError(translate("sign_up.password_doesnt_match"));
      }
    }

    setState(() {
      termsPrivacyError = termsPrivacy ? false : true;
    });
  }

  Future<void> signUp() async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: emailEditingController.text,
        password: passwordEditingController.text,
      );
      addUser();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSignUpError(translate("sign_up.weak_password"));
      } else if (e.code == 'email-already-in-use') {
        showSignUpError(translate("sign_up.email_in_use"));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addUser() {
    String uid = firebaseAuth.currentUser?.uid ?? "";

    if (uid.isNotEmpty) {
      final user = <String, dynamic>{
        "firstName": firstNameEditingController.text,
        "email": emailEditingController.text
      };
      firebaseFirestore.collection("users").doc(uid).set(user);
    }
  }

  void showSignUpError(String message) {
    setState(() {
      signUpError = true;
      signUpErrorMessage = message;
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
                                  tooltip: translate("sign_up.go_back"),
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
                                  Text(translate("sign_up.title"),
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
                                                label: translate(
                                                    "sign_up.first_name"),
                                                textEditingController:
                                                    firstNameEditingController,
                                                initialValue: "",
                                                obscureText: false,
                                                textInputType:
                                                    TextInputType.name,
                                                formFieldType:
                                                    FormFieldType.text,
                                                onChanged: () {},
                                                required: true),
                                            DefaultInput(
                                                label:
                                                    translate("sign_up.email"),
                                                textEditingController:
                                                    emailEditingController,
                                                initialValue: "",
                                                obscureText: false,
                                                textInputType:
                                                    TextInputType.emailAddress,
                                                formFieldType:
                                                    FormFieldType.email,
                                                onChanged: () {},
                                                required: true),
                                            DefaultInput(
                                                label: translate(
                                                    "sign_up.password"),
                                                textEditingController:
                                                    passwordEditingController,
                                                initialValue: "",
                                                obscureText: true,
                                                textInputType:
                                                    TextInputType.text,
                                                formFieldType:
                                                    FormFieldType.text,
                                                onChanged: () {},
                                                required: true),
                                            DefaultInput(
                                                label: translate(
                                                    "sign_up.confirm_password"),
                                                textEditingController:
                                                    confirmPasswordEditingController,
                                                initialValue: "",
                                                obscureText: true,
                                                textInputType:
                                                    TextInputType.text,
                                                formFieldType:
                                                    FormFieldType.text,
                                                onChanged: () {},
                                                required: true)
                                          ]))),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                          checkColor: Palette.onBackground,
                                          fillColor:
                                              MaterialStateProperty.resolveWith(
                                                  (_) {
                                            return termsPrivacyError
                                                ? Palette.error
                                                : Palette.primary;
                                          }),
                                          value: termsPrivacy,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              termsPrivacyError = false;
                                              termsPrivacy = value!;
                                            });
                                          },
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Utils.openURL(
                                                  "https://walmin.com/toolboxes/privacypolicy.html",
                                                  false);
                                            },
                                            child: RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                    style: TextStyle(
                                                        color: termsPrivacyError
                                                            ? Palette.error
                                                            : Palette
                                                                .onBackground,
                                                        fontSize: 16),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: translate(
                                                            "sign_up.agree"),
                                                      ),
                                                      TextSpan(
                                                          text: translate(
                                                              "sign_up.terms_and_privacy"),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ]))),
                                      ]),
                                  if (signUpError)
                                    Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(signUpErrorMessage,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Palette.error,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16))),
                                ]))
                          ]))),
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 32, left: 32, right: 32),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultButton(
                            title: translate("sign_up.sign_up"),
                            backgroundColor: Palette.primary,
                            textColor: Palette.onPrimary,
                            onPress: validateForm)
                      ]))
            ]))));
  }
}
