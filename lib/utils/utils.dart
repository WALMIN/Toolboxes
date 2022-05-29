import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

enum FormFieldType { email, text, date }

class Utils {
  // Default app bar
  static AppBar appBar = AppBar(
      toolbarHeight: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ));

  // Show snack bar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
    ));
  }

  // Capitalize first letter
  static String capitalize(String input) {
    return "${input[0].toUpperCase()}${input.substring(1)}";
  }

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
        } else if (formField == FormFieldType.date) {
          return validateFieldRegex(
              value,
              r"^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$",
              FormFieldType.date);
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
      } else if (formField == FormFieldType.date) {
        return translate("validator.field_date");
      }
    }
  }

  // Open a url
  static Future<void> openURL(String url, bool openBrowser) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: openBrowser
          ? LaunchMode.externalApplication
          : LaunchMode.inAppWebView,
    )) {
      throw 'Could not open $url';
    }
  }

  static Future<String> showDatePickerDialog(
      BuildContext context, DateTime dateTime) async {
    final DateTime? dateTimePicked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    String date =
        "${dateTime.toLocal().year}-${dateTime.toLocal().month < 10 ? "0" : ""}${dateTime.toLocal().month}-${dateTime.toLocal().day < 10 ? "0" : ""}${dateTime.toLocal().day}";

    if (dateTimePicked != null && dateTimePicked != dateTime) {
      date =
          "${dateTimePicked.toLocal().year}-${dateTimePicked.toLocal().month < 10 ? "0" : ""}${dateTimePicked.toLocal().month}-${dateTimePicked.toLocal().day < 10 ? "0" : ""}${dateTimePicked.toLocal().day}";
    }
    return date;
  }
}
