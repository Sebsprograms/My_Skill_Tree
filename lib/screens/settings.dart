import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/user.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_auth.dart';
import 'package:my_skill_tree/utils/globals.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final AppUser user = Provider.of<UserProvider>(context).user!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Settings for ${user.name}',
              style: Theme.of(context).textTheme.headlineLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Change Ui color:'),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: user.uiColor,
                onChanged: (String? color) {
                  if (color == null) return;
                  Provider.of<UserProvider>(context, listen: false)
                      .updateUserColor(color);
                },
                items: appColors.values.map((color) {
                  String value = appColors.keys
                      .firstWhere((key) => appColors[key] == color);
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Container(
                          color: color,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
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
