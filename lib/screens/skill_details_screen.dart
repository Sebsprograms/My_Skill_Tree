import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/skill.dart';
import 'package:my_skill_tree/screens/activity_list.dart';
import 'package:my_skill_tree/widgets/difficulty_emblem.dart';
import 'package:my_skill_tree/widgets/level_emblem.dart';
import 'package:my_skill_tree/widgets/xp_bar.dart';

class SkillDetailsScreen extends StatefulWidget {
  const SkillDetailsScreen({
    super.key,
    required this.skill,
  });

  final Skill skill;

  @override
  State<SkillDetailsScreen> createState() => _SkillDetailsScreenState();
}

class _SkillDetailsScreenState extends State<SkillDetailsScreen> {
  bool _editing = false;

  void toggleEditing() {
    setState(() {
      _editing = !_editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: !_editing,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.skill.name,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          _editing
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                )
              : const SizedBox(),
          _editing
              ? IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {},
                )
              : const SizedBox(),
          IconButton(
            icon: Icon(_editing ? Icons.close : Icons.edit),
            onPressed: toggleEditing,
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LevelEmblem(
                        level: widget.skill.currentLevel,
                        color: widget.skill.color,
                        size: 72,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          XpBar(
                            currentXp: widget.skill.currentXp,
                            xpToNextLevel: widget.skill.xpToNextLevel,
                            height: 20,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DifficultyEmblem(
                                  difficulty: widget.skill.difficulty),
                              Text(
                                'XP: ${widget.skill.currentXp}/${widget.skill.xpToNextLevel}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.skill.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  Text('Activities',
                      style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
            Expanded(
              child: ActivityList(),
            ),
          ],
        ),
      ),
    );
  }
}
