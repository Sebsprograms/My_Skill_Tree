import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/skill.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_firestore.dart';
import 'package:my_skill_tree/widgets/skill_card.dart';
import 'package:provider/provider.dart';

class SkillList extends StatelessWidget {
  const SkillList({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    if (user.user == null) {
      return Container(
        color: Theme.of(context).colorScheme.secondary,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.all(16),
      child: StreamBuilder(
        stream: FirestoreMethods().skillStream(user.user!),
        builder: (BuildContext context, AsyncSnapshot<List<Skill>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                color: Theme.of(context).colorScheme.secondary,
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
          }
          final skills = snapshot.data!;
          return ListView.builder(
            itemCount: skills.length,
            itemBuilder: (BuildContext context, int index) {
              final skill = skills[index];
              return SkillCard(skill: skill, key: ValueKey(skill.id));
            },
          );
        },
      ),
    );
  }
}
