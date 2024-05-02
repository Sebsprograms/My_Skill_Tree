import 'package:flutter/material.dart';
import 'package:my_skill_tree/resources/firebase_auth.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                await AuthMethods().signOutUser();
              },
              child: const Text('Sign Out')),
        ],
      ),
    );
  }
}
