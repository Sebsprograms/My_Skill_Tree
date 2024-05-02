import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:my_skill_tree/models/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required Color uiColor,
  }) async {
    String response = 'something went wrong';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Add credentials to Firebase Authentication
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Create user object and add to user collection in Firestore
        AppUser user = AppUser(
          uid: credential.user!.uid,
          email: email,
          uiColor: uiColor,
          name: name,
        );

        await _firestore.collection('users').doc(credential.user!.uid).set(
              user.toJson(),
            );

        response = 'success';
      } else {
        response = 'Please fill out all fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        response = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        response = 'The account already exists for that email.';
      }
    } catch (e) {
      response = e.toString();
    }

    return response;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String response = 'something went wrong';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        response = 'success';
      } else {
        response = 'email or password is empty';
      }
    } catch (e) {
      response = e.toString();
    }

    return response;
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}
