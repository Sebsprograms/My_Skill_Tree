import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  Color _uiColor = Colors.green;

  Color get uiColor => _uiColor;

  void setUiColor(Color color) {
    _uiColor = color;
    notifyListeners();
  }
}
