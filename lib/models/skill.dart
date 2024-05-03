import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Skill {
  String? id;
  String name;
  String description;
  Color color;
  int currentLevel;
  int currentXp;
  int xpToNextLevel;
  Difficulty difficulty;

  Skill({
    this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.currentLevel,
    required this.currentXp,
    required this.xpToNextLevel,
    required this.difficulty,
  });

  static Skill fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Skill(
      id: snapshot.id,
      name: data['name'],
      description: data['description'],
      color: Color(data['color']),
      currentLevel: data['currentLevel'],
      currentXp: data['currentXp'],
      xpToNextLevel: data['xpToNextLevel'],
      difficulty: DifficultyExtension.fromString(data['difficulty']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'color': color.value,
      'currentLevel': currentLevel,
      'currentXp': currentXp,
      'xpToNextLevel': xpToNextLevel,
      'difficulty': difficulty.name,
    };
  }
}

enum Difficulty {
  ss,
  s,
  a,
  b,
  c,
  d,
}

extension DifficultyExtension on Difficulty {
  String get name {
    switch (this) {
      case Difficulty.ss:
        return 'SS';
      case Difficulty.s:
        return 'S';
      case Difficulty.a:
        return 'A';
      case Difficulty.b:
        return 'B';
      case Difficulty.c:
        return 'C';
      case Difficulty.d:
        return 'D';
    }
  }

  int get difficultyXpIncrease {
    switch (this) {
      case Difficulty.ss:
        return 50;
      case Difficulty.s:
        return 25;
      case Difficulty.a:
        return 20;
      case Difficulty.b:
        return 15;
      case Difficulty.c:
        return 10;
      case Difficulty.d:
        return 5;
    }
  }

  static Difficulty fromString(String name) {
    switch (name) {
      case 'SS':
        return Difficulty.ss;
      case 'S':
        return Difficulty.s;
      case 'A':
        return Difficulty.a;
      case 'B':
        return Difficulty.b;
      case 'C':
        return Difficulty.c;
      case 'D':
      default:
        return Difficulty.d;
    }
  }

  Color get color {
    switch (this) {
      case Difficulty.ss:
        return Colors.red;
      case Difficulty.s:
        return Colors.purple;
      case Difficulty.a:
        return Colors.orange;
      case Difficulty.b:
        return Colors.yellow;
      case Difficulty.c:
        return Colors.blue;
      case Difficulty.d:
        return Colors.green;
    }
  }
}

final dummySkills = [
  Skill(
    id: '1',
    name: 'Running',
    description:
        'Running, sprinting and marathons. lorem ipsum dolor sit amet. lorem lorem ipsum dolor sit amet. lorem lorem ipsum dolor sit amet. lorem lorem ipsum dolor sit amet. lorem lorem ipsum dolor sit amet. lorem lorem ipsum dolor sit amet. lorem ',
    color: Colors.green,
    currentLevel: 1,
    currentXp: 99,
    xpToNextLevel: 100,
    difficulty: Difficulty.d,
  ),
  Skill(
    id: '2',
    name: 'Reading',
    description: 'Anything book related like reading, writing, etc.',
    color: Colors.blue,
    currentLevel: 1,
    currentXp: 0,
    xpToNextLevel: 100,
    difficulty: Difficulty.c,
  ),
  Skill(
    id: '3',
    name: 'Coding',
    description: 'Programming, theory, algorithms, etc.',
    color: Colors.purple,
    currentLevel: 1,
    currentXp: 0,
    xpToNextLevel: 100,
    difficulty: Difficulty.a,
  ),
  Skill(
    id: '4',
    name: 'Meditation',
    description: 'All styles of meditation and mindfulness.',
    color: Colors.orange,
    currentLevel: 999,
    currentXp: 50,
    xpToNextLevel: 100,
    difficulty: Difficulty.a,
  ),
  Skill(
    id: '5',
    name: 'Cooking',
    description: 'Culinary arts, recipes, techniques, etc.',
    color: Colors.red,
    currentLevel: 100,
    currentXp: 0,
    xpToNextLevel: 100,
    difficulty: Difficulty.ss,
  ),
];
