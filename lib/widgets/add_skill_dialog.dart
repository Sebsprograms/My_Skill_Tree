import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/skill.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_firestore.dart';
import 'package:my_skill_tree/utils/globals.dart';
import 'package:provider/provider.dart';

class AddSkillDialog extends StatefulWidget {
  const AddSkillDialog({super.key});

  @override
  State<AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends State<AddSkillDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  Color _color = Colors.blue;
  Difficulty _difficulty = Difficulty.ss;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UserProvider user = Provider.of<UserProvider>(context, listen: false);
      final skill = Skill(
        name: _name,
        description: _description,
        color: _color,
        difficulty: _difficulty,
        currentLevel: 1,
        currentXp: 0,
        xpToNextLevel: 100,
      );
      await FirestoreMethods().addSkill(user.user!, skill);
      _formKey.currentState!.reset();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      title: Text('Add Skill'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length > 100) {
                    return 'Description must be less than 100 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: DropdownButtonFormField<Color>(
                  value: _color,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                  ),
                  items: skillColors.entries
                      .map((e) => DropdownMenuItem(
                            value: e.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: e.value,
                                ),
                                const SizedBox(width: 6),
                                Text(e.key),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _color = value!;
                    });
                  },
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: DropdownButtonFormField<Difficulty>(
                  value: _difficulty,
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                  ),
                  items: Difficulty.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _difficulty = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _formKey.currentState!.reset();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _submit();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
