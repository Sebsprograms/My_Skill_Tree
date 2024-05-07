import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/activity.dart';
import 'package:my_skill_tree/models/skill.dart';
import 'package:my_skill_tree/models/user.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_firestore.dart';
import 'package:my_skill_tree/utils/globals.dart';
import 'package:my_skill_tree/widgets/level_emblem.dart';
import 'package:provider/provider.dart';

enum CooldownOptions {
  minutes,
  hours,
  days,
}

class AddActivityDialog extends StatefulWidget {
  const AddActivityDialog({super.key});

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  Reward reward = Reward.tiny;
  Skill? _selectedSkill;
  List<Skill> _skills = [];
  AppUser? _user;
  CooldownOptions _selectedCooldownOption = CooldownOptions.minutes;
  int cooldownValue = 15;

  IconData _icon = appIcons.values.first;

  initData() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    if (user.user != null) {
      _user = user.user;
    }
    final skills = await FirestoreMethods().getSkills(user.user!);
    setState(() {
      _skills = skills;
    });
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> _submit(AppUser user) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Duration cooldown = const Duration();
      switch (_selectedCooldownOption) {
        case CooldownOptions.minutes:
          cooldown = Duration(minutes: cooldownValue);
          break;
        case CooldownOptions.hours:
          cooldown = Duration(hours: cooldownValue);
          break;
        case CooldownOptions.days:
          cooldown = Duration(days: cooldownValue);
          break;
      }

      final activity = Activity(
        name: _name,
        reward: reward,
        icon: _icon,
        skillId: _selectedSkill!.id!,
        skillColor: _selectedSkill!.color,
        cooldown: cooldown,
      );
      await FirestoreMethods().addActivity(user, activity);
      _formKey.currentState!.reset();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      title: const Text('Add Activity'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  if (value.length > 20) {
                    return 'Name must be 20 characters or less';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: DropdownButtonFormField<Skill>(
                  value: _selectedSkill,
                  items: _skills
                      .map((skill) => DropdownMenuItem(
                            value: skill,
                            child: Row(
                              children: [
                                LevelEmblem(
                                  level: skill.currentLevel,
                                  color: skill.color,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Text(skill.name),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSkill = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Skill'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a skill';
                    }
                    return null;
                  },
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: DropdownButtonFormField<Reward>(
                  value: reward,
                  items: Reward.values
                      .map((reward) => DropdownMenuItem(
                            value: reward,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(reward.name),
                                const SizedBox(width: 12),
                                Text('+ ${reward.value} XP'),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      reward = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Reward'),
                ),
              ),
              Row(
                children: [
                  const Text('Cooldown:'),
                  const SizedBox(width: 12),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: DropdownButton<CooldownOptions>(
                      value: _selectedCooldownOption,
                      items: CooldownOptions.values
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option.toString().split('.').last),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCooldownOption = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      initialValue: cooldownValue.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        cooldownValue = int.parse(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: DropdownButton<IconData>(
                  value: _icon,
                  items: appIcons.values
                      .map((icon) => DropdownMenuItem(
                            value: icon,
                            child: Row(
                              children: [
                                Icon(icon),
                                const SizedBox(width: 12),
                                Text(appIcons.keys.firstWhere(
                                    (key) => appIcons[key] == icon)),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _icon = value!;
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
            _submit(_user!);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
