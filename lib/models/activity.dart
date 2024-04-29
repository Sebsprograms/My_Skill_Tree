import 'package:flutter/material.dart';

class Activity {
  final String name;
  final Reward reward;
  final IconData icon;
  final Color skillColor;
  final Duration cooldown;

  Activity({
    required this.name,
    required this.reward,
    required this.icon,
    required this.skillColor,
    required this.cooldown,
  });
}

enum Reward {
  tiny,
  small,
  medium,
  large,
  huge,
}

extension RewardExtension on Reward {
  String get name {
    switch (this) {
      case Reward.tiny:
        return 'Tiny';
      case Reward.small:
        return 'Small';
      case Reward.medium:
        return 'Medium';
      case Reward.large:
        return 'Large';
      case Reward.huge:
        return 'Huge';
    }
  }

  int get value {
    switch (this) {
      case Reward.tiny:
        return 5;
      case Reward.small:
        return 10;
      case Reward.medium:
        return 25;
      case Reward.large:
        return 50;
      case Reward.huge:
        return 100;
    }
  }

  Color get color {
    switch (this) {
      case Reward.tiny:
        return Colors.green;
      case Reward.small:
        return Colors.blue;
      case Reward.medium:
        return Colors.purple;
      case Reward.large:
        return Colors.orange;
      case Reward.huge:
        return Colors.red;
    }
  }
}
