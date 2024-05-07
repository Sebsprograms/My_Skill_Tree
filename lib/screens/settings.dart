import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_skill_tree/models/user.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_auth.dart';
import 'package:my_skill_tree/utils/globals.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isEditMode = false;
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() async {
    if (_nameController.text.isNotEmpty) {
      await AuthMethods().updateUserName(_nameController.text);
      setState(() {
        _isEditMode = false;
      });
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.getCurrentUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppUser user = Provider.of<UserProvider>(context).user!;
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_isEditMode)
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your name',
                          ),
                        ),
                      ),
                    if (!_isEditMode)
                      Text(user.name,
                          style: Theme.of(context).textTheme.headlineMedium),
                    if (_isEditMode)
                      IconButton(
                        onPressed: _saveName,
                        icon: Icon(Icons.save, size: 24),
                      ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isEditMode = !_isEditMode;
                          });
                        },
                        icon: Icon(_isEditMode ? Icons.close : Icons.edit,
                            size: 24)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Change Ui color:',
                        style: TextStyle(
                          fontSize: 16,
                        )),
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
                                width: 40,
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
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Unrestricted Pro member:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    const Text(
                      'No',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    'Purchase Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await AuthMethods().signOutUser();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
