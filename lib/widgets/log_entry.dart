import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/activity.dart';
import 'package:my_skill_tree/models/log.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_firestore.dart';
import 'package:provider/provider.dart';

class LogEntry extends StatelessWidget {
  const LogEntry({
    super.key,
    required this.log,
  });

  final Log log;

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return FutureBuilder(
        future:
            FirestoreMethods().getOneActivityById(user.user!, log.activityId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.data == null) {
            return const Text('No logs yet');
          }

          Activity activity = snapshot.data!;

          return Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: ListTile(
              leading: Text(
                '+ ${activity.reward.value} XP',
                style: TextStyle(
                  color: activity.skillColor,
                  fontSize: 20,
                ),
              ),
              title: Text(activity.name),
              subtitle: Text(log.timeStamp.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await FirestoreMethods()
                      .deleteLogEntryAndDecrementSkill(user.user!, log);
                },
              ),
            ),
          );
        });
  }
}
