import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/skill.dart';
import 'package:my_skill_tree/widgets/difficulty_emblem.dart';
import 'package:my_skill_tree/widgets/level_emblem.dart';
import 'package:my_skill_tree/widgets/skill_card.dart';
import 'package:my_skill_tree/widgets/xp_bar.dart';

class SkillList extends StatelessWidget {
  const SkillList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: dummySkills.length,
        itemBuilder: (BuildContext context, int index) {
          final skill = dummySkills[index];
          return SkillCard(skill: skill);
        },
      ),
    );
  }
}
