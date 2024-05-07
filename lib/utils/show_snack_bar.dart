import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Function? undoAction) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
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
