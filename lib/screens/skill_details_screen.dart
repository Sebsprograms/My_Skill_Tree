import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/skill.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_firestore.dart';
import 'package:my_skill_tree/screens/activity_list.dart';
import 'package:my_skill_tree/widgets/difficulty_emblem.dart';
import 'package:my_skill_tree/widgets/level_emblem.dart';
import 'package:my_skill_tree/widgets/xp_bar.dart';
import 'package:provider/provider.dart';

class SkillDetailsScreen extends StatefulWidget {
  const SkillDetailsScreen({
    super.key,
    required this.skillId,
  });

  final String skillId;

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
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    return StreamBuilder(
      stream: FirestoreMethods().oneSkillStream(user.user!, widget.skillId),
      builder: (BuildContext context, AsyncSnapshot<Skill> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null) {
          return const Center(child: Text('Skill not found'));
        }

        final Skill skill = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            centerTitle: !_editing,
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              skill.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            actions: [
              _editing
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        FirestoreMethods().deleteSkill(user.user!, skill);
                        Navigator.pop(context);
                      },
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
                Container(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LevelEmblem(
                            level: skill.currentLevel,
                            color: skill.color,
                            size: 72,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              XpBar(
                                currentXp: skill.currentXp,
                                xpToNextLevel: skill.xpToNextLevel,
                                height: 20,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DifficultyEmblem(
                                      difficulty: skill.difficulty),
                                  Text(
                                    'XP: ${skill.currentXp}/${skill.xpToNextLevel}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        skill.description,
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
                  child: ActivityList(
                    activitiesStream: FirestoreMethods()
                        .activitiesForSkillStream(user.user!, skill.id!),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
