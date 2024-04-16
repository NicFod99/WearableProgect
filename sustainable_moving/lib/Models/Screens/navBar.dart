import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/Screens/PathChoosing.dart';
import 'package:sustainable_moving/Models/Screens/home.dart';
import 'package:sustainable_moving/Models/Screens/getDistance.dart';
import 'package:sustainable_moving/Models/Screens/homepage.dart';
import 'package:sustainable_moving/Models/Screens/profilePage.dart';
import 'package:sustainable_moving/Models/Screens/trainingPage.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  static const routename = 'Navigation Bar';

  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ChoosePage(),
          PathChoosingFeature(),
          ProfilePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int newindex) {
          setState(() {
            _selectedIndex = newindex;
          });
        },
        iconSize: 25, // Adjust the icon size
        selectedItemColor: Colors.green, // Adjust the selected item color
        unselectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.roundabout_left),
            label: 'Path',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
