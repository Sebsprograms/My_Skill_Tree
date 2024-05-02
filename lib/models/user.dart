import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final Color uiColor;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.uiColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'uiColor': uiColor.value,
    };
  }

  static AppUser fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return AppUser(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      uiColor: Color(data['uiColor']),
    );
  }
}
