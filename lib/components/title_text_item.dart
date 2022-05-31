import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../utils/palette.dart';
import '../utils/utils.dart';

class TitleTextItem extends StatefulWidget {
  final String title;
  final String text;
  final CrossAxisAlignment crossAxisAlignment;

  const TitleTextItem(
      {Key? key,
      required this.title,
      required this.text,
      required this.crossAxisAlignment})
      : super(key: key);

  @override
  State<TitleTextItem> createState() => _TitleTextItemState();
}

class _TitleTextItemState extends State<TitleTextItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.circle,
                size: 10,
                color: Palette.primary,
              ),
            ),
            Text(Utils.capitalize(widget.title),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Palette.onSurface, fontSize: 18)),
          ]),
          Text(
              widget.text.isNotEmpty
                  ? Utils.capitalize(widget.text)
                  : translate("title_text_item.empty"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: widget.text.isNotEmpty
                      ? Palette.onSurface
                      : Palette.onSurfaceSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ],
      ),
    );
  }
}
