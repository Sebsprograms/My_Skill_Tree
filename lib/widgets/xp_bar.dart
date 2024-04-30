import 'package:flutter/material.dart';

class XpBar extends StatelessWidget {
  const XpBar({
    super.key,
    required this.currentXp,
    required this.xpToNextLevel,
  });

  final int currentXp;
  final int xpToNextLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 8,
      child: LinearProgressIndicator(
        value: currentXp / xpToNextLevel,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
    );
  }
}
