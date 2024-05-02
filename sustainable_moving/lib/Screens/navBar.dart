import 'package:flutter/material.dart';
import 'package:sustainable_moving/Screens/FavoritePage.dart';
import 'package:sustainable_moving/Screens/getDistance.dart';
import 'package:sustainable_moving/Screens/pathChoosing.dart';
import 'package:sustainable_moving/Screens/home.dart';
import 'package:sustainable_moving/Screens/profilePage.dart';
import 'package:sustainable_moving/Screens/trainingPage.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

/* E' la pagin più importante, è la pagina richiamata post login.
 * In realtà non è una pagina ma la barra di sotto, la prima pagina che viene 
 * mostrata, è quella con indice 0 (ossia home).
 * Se volete aggiungere pagine dovete aggiornare IndexedStack e la BottomNavigat
 * ion bar.
 * 
 * TODO: Mettere max 5 bottoni, fare in modo che non si debba utilizzare tutti i
 * bottoni per utilizzare ogni funzionalità. */

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
          FavoritePage(),
          TrainingPage(),
          GetDistanceFeature(),
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
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.activity),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.arrowCircleDownOutline),
            label: 'Distance',
          ),
        ],
      ),
    );
  }
}
