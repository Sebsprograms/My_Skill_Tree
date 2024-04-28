import 'package:flutter/material.dart';
import 'package:my_skill_tree/screens/layout.dart';
import 'package:my_skill_tree/utils/globals.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentColorIndex = 0;

  void toggleTheme() {
    setState(() {
      currentColorIndex = (currentColorIndex + 1) % appColors.length;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final allColors = appColors.values.toList();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // check user collection for selected ui color.
        colorScheme:
            ColorScheme.fromSeed(seedColor: allColors[currentColorIndex]),
        useMaterial3: true,
      ),
      // Check for auth before rendering layout here
      home: Layout(
        toggleTheme: toggleTheme,
      ),
    );
  }
}
