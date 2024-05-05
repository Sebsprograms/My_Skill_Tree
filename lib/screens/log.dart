import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/log.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_firestore.dart';
import 'package:my_skill_tree/widgets/log_entry.dart';
import 'package:provider/provider.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.all(16),
      child: StreamBuilder(
        stream: FirestoreMethods().logsStream(userProvider.user!),
        builder: (context, AsyncSnapshot<List<Log>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No activities in log yet!',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final Log log = snapshot.data![index];
              return LogEntry(log: log, key: ValueKey(log.id));
            },
          );
        },
      ),
    );
  }
}
