import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../utils/palette.dart';
import '../utils/utils.dart';

class DefaultInput extends StatefulWidget {
  final String label;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final FormFieldType formFieldType;

  const DefaultInput(
      {Key? key,
      required this.label,
      required this.textEditingController,
      required this.textInputType,
      required this.formFieldType})
      : super(key: key);

  @override
  State<DefaultInput> createState() => _DefaultInputState();
}

class _DefaultInputState extends State<DefaultInput> {
  bool loading = false;
  bool showError = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        maxLines: 1,
        autocorrect: true,
        validator: (value) {
          return Utils.validateField(true, value, widget.formFieldType);
        },
        controller: widget.textEditingController,
        keyboardType: widget.textInputType,
        style: const TextStyle(
          color: Palette.onBackground,
        ),
        onChanged: (value) {
          if (showError) {
            loading = false;
            showError = false;
            errorMessage = "";
          }
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
                borderSide: BorderSide(color: Palette.onBackground)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Palette.onBackground)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Palette.onBackground)),
            labelStyle: const TextStyle(
              color: Palette.onBackground,
            ),
            labelText: translate(widget.label)),
      ),
    );
  }
}
