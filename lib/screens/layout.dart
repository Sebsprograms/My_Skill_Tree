import 'package:flutter/material.dart';
import 'package:my_skill_tree/providers/user_provider.dart';
import 'package:my_skill_tree/resources/firebase_firestore.dart';
import 'package:my_skill_tree/screens/activity_list.dart';
import 'package:my_skill_tree/screens/loading_screen.dart';
import 'package:my_skill_tree/screens/log.dart';
import 'package:my_skill_tree/screens/settings.dart';
import 'package:my_skill_tree/screens/skills_list.dart';
import 'package:my_skill_tree/widgets/add_activity_dialog.dart';
import 'package:my_skill_tree/widgets/add_skill_dialog.dart';
import 'package:provider/provider.dart';

const pageTitles = [
  'Activities',
  'Statistics',
  'Skills',
  'Log',
  'Settings',
];

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _page = 0;
  PageController _pageController = PageController();

  initUserData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    if (userProvider.user != null) return;
    await userProvider.getCurrentUser();
  }

  @override
  void initState() {
    initUserData();
    _pageController = PageController(initialPage: _page);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    if (user.user == null) {
      return const LoadingScreen();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          pageTitles[_page],
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          if (_page == 0)
            IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 30.0,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AddActivityDialog();
                    });
              },
            ),
          if (_page == 2)
            IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 30.0,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AddSkillDialog();
                    });
              },
            ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _page = page;
          });
        },
        children: <Widget>[
          ActivityList(
            activitiesStream:
                FirestoreMethods().allActivitiesStream(user.user!),
          ),
          const Center(
            child: Text('Statistics'),
          ),
          const SkillList(),
          const LogScreen(),
          const Settings(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        currentIndex: _page,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() {
            _page = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.workspaces_outline,
            ),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart_rounded,
            ),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.linear_scale_rounded,
            ),
            label: 'Skills',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
