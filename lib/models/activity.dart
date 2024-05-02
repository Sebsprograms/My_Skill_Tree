import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String name;
  final Reward reward;
  final IconData icon;
  final Color skillColor;
  final String skillId;
  final Duration cooldown;

  Activity({
    required this.id,
    required this.name,
    required this.reward,
    required this.icon,
    required this.skillColor,
    required this.cooldown,
    required this.skillId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'reward': reward.name,
      'icon': icon.codePoint,
      'skillColor': skillColor.value,
      'skillId': skillId,
      'cooldown': cooldown.inMilliseconds,
    };
  }

  static Activity fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Activity(
      id: snapshot.id,
      name: data['name'],
      reward: RewardExtension.fromString(data['reward']),
      icon: IconData(data['icon'], fontFamily: 'MaterialIcons'),
      skillColor: Color(data['skillColor']),
      skillId: data['skillId'],
      cooldown: Duration(milliseconds: data['cooldown']),
    );
  }
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

  static Reward fromString(String name) {
    switch (name) {
      case 'Tiny':
        return Reward.tiny;
      case 'Small':
        return Reward.small;
      case 'Medium':
        return Reward.medium;
      case 'Large':
        return Reward.large;
      case 'Huge':
        return Reward.huge;
      default:
        return Reward.tiny;
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
}
