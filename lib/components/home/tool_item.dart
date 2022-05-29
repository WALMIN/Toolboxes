import 'package:flutter/material.dart';
import 'package:toolboxes/models/tool_model.dart';

import '../../utils/palette.dart';
import '../../utils/utils.dart';

class ToolItem extends StatefulWidget {
  final ToolModel toolModel;
  const ToolItem({Key? key, required this.toolModel}) : super(key: key);

  @override
  State<ToolItem> createState() => _ToolItemState();
}

class _ToolItemState extends State<ToolItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Palette.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Palette.surface.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Stack(children: [
        Positioned(
            top: 0,
            left: 0,
            child: CircleAvatar(
                backgroundColor:
                    widget.toolModel.borrowed ? Palette.red : Palette.green,
                radius: 5)),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Utils.capitalize(widget.toolModel.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Palette.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Text(Utils.capitalize(widget.toolModel.storagePlace),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Palette.onSurface,
                        fontWeight: FontWeight.w300,
                        fontSize: 14)),
              ]),
        )
      ]),
    );
  }
}
