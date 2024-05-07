import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_skill_tree/firebase_options.dart';
import 'package:my_skill_tree/models/user.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/screens/auth_screen.dart';
import 'package:my_skill_tree/screens/layout.dart';
import 'package:my_skill_tree/screens/loading_screen.dart';
import 'package:my_skill_tree/utils/globals.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MySkillTree());
}

class MySkillTree extends StatelessWidget {
  const MySkillTree({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
    ], child: const App());
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Color uiColor = appColors.values.first;

  void setUiColor(Color color) {
    setState(() {
      uiColor = color;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppUser? user = Provider.of<UserProvider>(context).user;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Skill Tree',
      theme: ThemeData(
        // check user collection for selected ui color.
        colorScheme: ColorScheme.fromSeed(
            seedColor: user != null ? appColors[user.uiColor]! : uiColor),
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
