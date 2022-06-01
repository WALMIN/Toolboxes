import 'package:flutter/material.dart';

class SettingsModel {
  IconData icon;
  String title;
  Function onTap;

  SettingsModel({required this.icon, required this.title, required this.onTap});
}
