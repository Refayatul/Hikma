import 'package:flutter/material.dart';
import 'first_screen.dart';
import 'article_screen.dart';
import 'settings_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    FirstScreen(),
    ArticleScreen(),
    SettingsScreen(),
  ];

  void onTappedItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn to Pray'),
      ),
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Prayers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
            label: 'Settings',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onTappedItem,
        selectedItemColor: Colors.deepPurple[900],
      ),
    );
  }
}
