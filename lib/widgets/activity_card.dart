import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/activity.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    //  Conditionally render either the activity details or a cooldown
    Widget content = Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(activity.icon, color: activity.skillColor, size: 48),
                Text(
                  '+${activity.reward.value} XP',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: activity.skillColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Container(),
            ),
            Text(activity.name, style: Theme.of(context).textTheme.titleMedium),
            Text('Cooldown: ${activity.cooldown.inHours} hours'),
          ],
        ),
      ),
    );

    if (activity.cooldown.inHours > 2) {
      content = Stack(
        children: <Widget>[
          content,
          Positioned.fill(
              child: Center(
                  child: Icon(
            Icons.lock_clock,
            size: 136,
          ))),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(4),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Activity',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      'Cooldown',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      '00:00:00',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return content;
  }
}
