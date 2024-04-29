import 'package:flutter/material.dart';
import 'package:my_skill_tree/screens/activity_list.dart';

const pageTitles = ['Activities', 'Statistics', 'Skills', 'Log'];

class Layout extends StatefulWidget {
  const Layout({super.key, required this.toggleTheme});

  final void Function() toggleTheme;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _page = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: widget.toggleTheme,
        child: Icon(Icons.color_lens),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          pageTitles[_page],
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
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
          ActivityList(),
          Center(
            child: Text('Statistics'),
          ),
          Center(
            child: Text('Skills'),
          ),
          Center(
            child: Text('Log'),
          ),
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
        items: <BottomNavigationBarItem>[
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
        ],
      ),
    );
  }
}
