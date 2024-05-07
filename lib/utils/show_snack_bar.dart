import 'package:flutter/material.dart';

void showFloatingSnackbar(
    BuildContext context, String message, Function? undoAction) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 220,
            left: 10,
            right: 10),
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: Duration(seconds: 3),
        action: undoAction == null
            ? null
            : SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  undoAction();
                },
              )),
  );
}
