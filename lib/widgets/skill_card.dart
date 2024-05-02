import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/skill.dart';
import 'package:my_skill_tree/screens/skill_details_screen.dart';
import 'package:my_skill_tree/widgets/difficulty_emblem.dart';
import 'package:my_skill_tree/widgets/level_emblem.dart';
import 'package:my_skill_tree/widgets/xp_bar.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({super.key, required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SkillDetailsScreen(skill: skill),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              LevelEmblem(
                level: skill.currentLevel,
                color: skill.color,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            skill.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          DifficultyEmblem(
                            difficulty: skill.difficulty,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: XpBar(
                        currentXp: skill.currentXp,
                        xpToNextLevel: skill.xpToNextLevel,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
