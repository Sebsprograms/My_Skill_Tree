import 'package:flutter/material.dart';
import 'package:my_skill_tree/models/skill.dart';

class DifficultyEmblem extends StatelessWidget {
  const DifficultyEmblem({
    super.key,
    required this.difficulty,
    this.size = 30,
  });

  final Difficulty difficulty;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: difficulty.color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          difficulty.name,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size / 1.8,
              ),
        ),
      ),
    );
  }
}
