import 'package:flutter/material.dart';
import 'package:sustainable_moving/PathChoosing.dart';
import 'package:sustainable_moving/getDistance.dart';
import 'package:sustainable_moving/homepage.dart';
import 'package:sustainable_moving/loginPage.dart';
import 'package:sustainable_moving/profilePage.dart'; // Import your booking page

class ChoosePage extends StatelessWidget {
  const ChoosePage({Key? key}) : super(key: key);

  static const routename = 'ChoosePage';

  @override
  Widget build(BuildContext context) {
    print('${ChoosePage.routename} built');

    return Scaffold(
      appBar: AppBar(
        title: Text(ChoosePage.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: Text('Go to Home Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GetDistanceFeature()));
              },
              child: Text('Go to Distance Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PathChoosingFeature()));
              },
              child: Text('Go to Booking Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: Text('login'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
        onTap: (index) {
          if (index == 0) {
            // Navigate to the "PathChoosing" page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PathChoosingFeature()),
            );
          }
          if (index == 1) {
            // Navigate to the "PathChoosing" page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
          if (index == 2) {
            // Navigate to the "PathChoosing" page
            print("TODO");
          }
        },
      ),
    );
  }
}
