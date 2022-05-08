import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';

enum FormFieldType { email, text }

class Utils {
  // Default app bar
  static AppBar appBar = AppBar(
      toolbarHeight: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ));

  // Validate field with regex
  static dynamic validateField(
      bool required, String? value, FormFieldType formField) {
    if (required) {
      if (value == null || value.trim().isEmpty) {
        return translate("validator.field_required");
      } else {
        if (formField == FormFieldType.email) {
          return validateFieldRegex(
              value,
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              FormFieldType.email);
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
  }

  // Validate field with regex
  static dynamic validateFieldRegex(
      String value, String pattern, FormFieldType formField) {
    if (!RegExp(pattern).hasMatch(value)) {
      if (formField == FormFieldType.email) {
        return translate("validator.field_email");
      }
    }
  }
}
