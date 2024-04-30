import 'package:flutter/material.dart';

class Skill {
  String id;
  String name;
  String description;
  Color color;
  int currentLevel;
  int currentXp;
  int xpToNextLevel;
  Difficulty difficulty;

  Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.currentLevel,
    required this.currentXp,
    required this.xpToNextLevel,
    required this.difficulty,
  });
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
