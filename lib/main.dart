import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_skill_tree/firebase_options.dart';
import 'package:my_skill_tree/screens/auth_screen.dart';
import 'package:my_skill_tree/screens/layout.dart';
import 'package:my_skill_tree/screens/loading_screen.dart';
import 'package:my_skill_tree/utils/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color uiColor = appColors.values.first;

  void setUiColor(Color color) {
    setState(() {
      uiColor = color;
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
        colorScheme: ColorScheme.fromSeed(seedColor: uiColor),
        useMaterial3: true,
      ),
      // Check for auth before rendering layout here
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.hasData) {
            return const Layout();
          }
          return AuthScreen(
            setUiColor: setUiColor,
            uiColor: uiColor,
          );
        },
      ),
    );
  }
}
