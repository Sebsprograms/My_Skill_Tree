import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/activity.dart';
import 'package:my_skill_tree/widgets/activity_card.dart';

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
          return const Center(child: Text('No activities yet'));
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
