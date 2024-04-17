import 'package:flutter/material.dart';
import 'package:sustainable_moving/Screens/PathChoosing.dart';
import 'package:sustainable_moving/Screens/editProfile.dart';
import 'package:sustainable_moving/Screens/favoritePage.dart';
import 'package:sustainable_moving/Screens/getDistance.dart';
import 'package:sustainable_moving/Screens/home.dart';
import 'package:sustainable_moving/Screens/navBar.dart';
import 'package:sustainable_moving/Screens/homepage.dart';
import 'package:sustainable_moving/Screens/loginPage.dart';
import 'package:sustainable_moving/Screens/profilePage.dart';
import 'package:sustainable_moving/Screens/trainingPage.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SustainableMovingApp());
}

class SustainableMovingApp extends StatelessWidget {
  const SustainableMovingApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favorite>(
      create: (context) => Favorite(),
      child: MaterialApp(
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
          FavoritePage.routename: (context) => FavoritePage(),
        },
      ),
    );
  }
}
