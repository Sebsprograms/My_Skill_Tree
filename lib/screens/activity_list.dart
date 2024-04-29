import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/activity.dart';
import 'package:my_skill_tree/widgets/activity_card.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    //  dummy activities
    final List<Activity> activities = [
      Activity(
        name: 'Running',
        reward: Reward.medium,
        icon: Icons.directions_run,
        skillColor: Colors.green,
        cooldown: const Duration(hours: 1),
      ),
      Activity(
        name: 'Reading',
        reward: Reward.small,
        icon: Icons.book,
        skillColor: Colors.blue,
        cooldown: const Duration(hours: 2),
      ),
      Activity(
        name: 'Coding',
        reward: Reward.large,
        icon: Icons.code,
        skillColor: Colors.purple,
        cooldown: const Duration(hours: 4),
      ),
      Activity(
        name: 'Coding',
        reward: Reward.huge,
        icon: Icons.code,
        skillColor: Colors.purple,
        cooldown: const Duration(hours: 4),
      ),
      Activity(
        name: 'Meditation',
        reward: Reward.medium,
        icon: Icons.self_improvement,
        skillColor: Colors.orange,
        cooldown: const Duration(hours: 1),
      ),
    ];

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: activities.length,
        itemBuilder: (BuildContext context, int index) {
          final Activity activity = activities[index];
          return ActivityCard(activity: activity);
        },
      ),
    );
  }
}
