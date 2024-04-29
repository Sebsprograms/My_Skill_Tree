import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/activity.dart';

class RewardEmblem extends StatelessWidget {
  RewardEmblem({super.key, required this.reward});

  Reward reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: reward.color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        '+ ${reward.value} XP',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
