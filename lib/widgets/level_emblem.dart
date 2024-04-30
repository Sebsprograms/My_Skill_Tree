import 'package:flutter/material.dart';

class LevelEmblem extends StatelessWidget {
  const LevelEmblem({
    super.key,
    required this.level,
    required this.color,
    this.size = 45,
  });

  final int level;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          level.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size / 2.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
