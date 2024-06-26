import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> _deleteLog(BuildContext context) async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    await FirestoreMethods().deleteLogEntryAndDecrementSkill(user.user!, log);
  }

  // Show are you sure dialog before deleting
  Future<void> _confirmDelete(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteLog(context);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
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
              subtitle: Text(
                  '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(log.timeStamp)} ${DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(log.timeStamp)}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _confirmDelete(context);
                },
              ),
            ),
          );
        });
  }
}
