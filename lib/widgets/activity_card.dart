import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/activity.dart';
import 'package:my_skill_tree/widgets/reward_emblem.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      // shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(activity.icon, color: activity.skillColor, size: 48),
                RewardEmblem(reward: activity.reward),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Text(activity.name, style: Theme.of(context).textTheme.titleMedium),
            Text('Cooldown: ${activity.cooldown.inHours} hours'),
          ],
        ),
      ),
    );
    ;
  }
}
