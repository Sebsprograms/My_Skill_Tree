import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/activity.dart';
import 'package:my_skill_tree/widgets/activity_card.dart';
import 'package:my_skill_tree/widgets/add_activity_dialog.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key, required this.activitiesStream});

  final Stream<List<Activity>> activitiesStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: activitiesStream,
      builder: (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return Container(
            color: Theme.of(context).colorScheme.secondary,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Add an activity to get started!',
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
                          return const AddActivityDialog();
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

        return Container(
          color: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.15,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final Activity activity = snapshot.data![index];
              return ActivityCard(
                  activity: activity, key: ValueKey(activity.id));
            },
          ),
        );
      },
    );
  }
}
