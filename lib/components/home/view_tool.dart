import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/components/title_text_item.dart';
import 'package:toolboxes/models/tool_model.dart';

import '../../utils/palette.dart';
import '../../utils/utils.dart';
import '../default_button.dart';
import 'add_edit_tool.dart';

class ViewTool extends StatefulWidget {
  final ToolModel toolModel;
  const ViewTool({Key? key, required this.toolModel}) : super(key: key);

  @override
  State<ViewTool> createState() => _ViewToolState();
}

class _ViewToolState extends State<ViewTool> {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firebaseFirestore;

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
  }

  Future<void> deleteTool() async {
    String uid = firebaseAuth.currentUser?.uid ?? "";

    if (uid.isNotEmpty) {
      await firebaseFirestore
          .collection("users")
          .doc(uid)
          .collection("tools")
          .doc(widget.toolModel.id)
          .delete()
          .then((value) {
        Navigator.pop(context);
        Utils.showSnackBar(
            context, translate("view_tool.successfully_deleted"));
      }).catchError((error) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Palette.surface,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(Utils.capitalize(widget.toolModel.name),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Palette.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            ),
            Row(children: [
              TitleTextItem(
                  title: translate("view_tool.storage_place"),
                  text: widget.toolModel.storagePlace,
                  crossAxisAlignment: CrossAxisAlignment.start)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TitleTextItem(
                  title: translate("view_tool.borrowed_by"),
                  text: widget.toolModel.borrowedBy,
                  crossAxisAlignment: CrossAxisAlignment.start),
              TitleTextItem(
                  title: translate("view_tool.borrowed_at"),
                  text: widget.toolModel.borrowedAt,
                  crossAxisAlignment: CrossAxisAlignment.end),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TitleTextItem(
                  title: translate("view_tool.bought"),
                  text: widget.toolModel.bought,
                  crossAxisAlignment: CrossAxisAlignment.start),
              TitleTextItem(
                  title: translate("view_tool.bought_at"),
                  text: widget.toolModel.boughtAt,
                  crossAxisAlignment: CrossAxisAlignment.end)
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultButton(
                        title: translate("view_tool.edit"),
                        backgroundColor: Palette.primary,
                        textColor: Palette.onPrimary,
                        onPress: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: AddEditTool(
                                          toolModel: widget.toolModel,
                                          edit: true)));
                            },
                          );
                        }),
                    DefaultButton(
                        title: translate("view_tool.delete"),
                        backgroundColor: Palette.red,
                        textColor: Palette.onPrimary,
                        onPress: () {
                          deleteTool();
                        })
                  ]),
            )
          ],
        ));
  }
}
