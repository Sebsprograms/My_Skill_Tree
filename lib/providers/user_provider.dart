import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/user.dart';
import 'package:my_skill_tree/resources/firebase_auth.dart';
import 'package:my_skill_tree/utils/globals.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _user;
  final AuthMethods _authMethods = AuthMethods();

  AppUser? get user => _user;

  Future<void> getCurrentUser() async {
    _user = await _authMethods.getCurrentUser();
    notifyListeners();
  }

  Future<void> updateUserColor(String colorKey) async {
    _user!.uiColor = colorKey;
    await _authMethods.updateUserColor(colorKey);
    notifyListeners();
  }
}
