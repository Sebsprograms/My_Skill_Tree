import 'package:flutter/material.dart';

class XpBar extends StatelessWidget {
  const XpBar({
    super.key,
    required this.currentXp,
    required this.xpToNextLevel,
    this.height = 8,
  });

  final int currentXp;
  final int xpToNextLevel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: LinearProgressIndicator(
        borderRadius: BorderRadius.circular(height / 2),
        value: currentXp / xpToNextLevel,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
