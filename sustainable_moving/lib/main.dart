import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/Screens/PathChoosing.dart';
import 'package:sustainable_moving/Models/Screens/editProfile.dart';
import 'package:sustainable_moving/Models/Screens/getDistance.dart';
import 'package:sustainable_moving/Models/Screens/home.dart';
import 'package:sustainable_moving/Models/Screens/navBar.dart';
import 'package:sustainable_moving/Models/Screens/homepage.dart';
import 'package:sustainable_moving/Models/Screens/loginPage.dart';
import 'package:sustainable_moving/Models/Screens/profilePage.dart';
import 'package:sustainable_moving/Models/Screens/trainingPage.dart';

void main() {
  runApp(SustainableMovingApp());
}

class SustainableMovingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sustainable Moving",
      initialRoute: HomePage.routename,
      routes: {
        HomePage.routename: (context) => HomePage(),
        GetDistanceFeature.routename: (context) => GetDistanceFeature(),
        NavBar.routename: (context) => NavBar(),
        ChoosePage.routename: (context) => ChoosePage(),
        PathChoosingFeature.routename: (context) => PathChoosingFeature(),
        LoginPage.routename: (context) => LoginPage(),
        EditProfile.routename: (context) => EditProfile(),
        ProfilePage.routename: (context) => ProfilePage(),
        TrainingPage.routename: (context) => TrainingPage(),
      },
    );
  }
}
