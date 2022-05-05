import 'package:flutter/material.dart';

class DefaultButton extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Function onPress;

  const DefaultButton(
      {Key? key,
      required this.title,
      required this.backgroundColor,
      required this.textColor,
      required this.onPress})
      : super(key: key);

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  double buttonHeight = 54;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            height: buttonHeight,
            margin: const EdgeInsets.only(left: 6, right: 6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: widget.backgroundColor,
                  onPrimary: widget.textColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: Text(
                widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                    fontSize: 20),
              ),
              onPressed: () {
                widget.onPress();
              },
            )));
  }
}
