import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/skill.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_firestore.dart';
import 'package:my_skill_tree/widgets/add_skill_dialog.dart';
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

          if (skills.isEmpty) {
            return Container(
              color: Theme.of(context).colorScheme.secondary,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Add a skill to get started!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AddSkillDialog();
                          });
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width > 600 ? 600 : null,
              child: ListView.builder(
                itemCount: skills.length,
                itemBuilder: (BuildContext context, int index) {
                  final skill = skills[index];
                  return SkillCard(skill: skill, key: ValueKey(skill.id));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
