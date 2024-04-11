import 'package:flutter/material.dart';
import 'package:sustainable_moving/Screens/PathChoosing.dart';
import 'package:sustainable_moving/Screens/editProfile.dart';
import 'package:sustainable_moving/Screens/getDistance.dart';
import 'package:sustainable_moving/Screens/home.dart';
import 'package:sustainable_moving/Screens/homepage.dart';
import 'package:sustainable_moving/Screens/loginPage.dart';
import 'package:sustainable_moving/Screens/profilePage.dart';
import 'package:sustainable_moving/Screens/trainingPage.dart';

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
        ChoosePage.routename: (context) => ChoosePage(),
        PathChoosingFeature.routename: (context) => PathChoosingFeature(),
        LoginPage.routename: (context) => LoginPage(),
        EditPage.routename: (context) => EditPage(),
        ProfilePage.routename: (context) => ProfilePage(),
        TrainingPage.routename: (context) => TrainingPage(),
      },
    );
  }
}
