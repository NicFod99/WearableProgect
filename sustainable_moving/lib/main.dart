import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sustainable_moving/Models/distanceNotifier.dart';
import 'package:sustainable_moving/Models/heartRateNotifier.dart';
import 'package:sustainable_moving/Screens/PathChoosing.dart';
import 'package:sustainable_moving/Screens/editProfile.dart';
import 'package:sustainable_moving/Screens/getDistance.dart';
import 'package:sustainable_moving/Screens/home.dart';
import 'package:sustainable_moving/Screens/navBar.dart';
import 'package:sustainable_moving/Screens/homepage.dart';
import 'package:sustainable_moving/Screens/loginPage.dart';
import 'package:sustainable_moving/Screens/trainingPage.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SustainableMovingApp());
}

class SustainableMovingApp extends StatelessWidget {
  const SustainableMovingApp({Key? key}) : super(key: key);

  // WRAP IN A FUTUREBUILDER PER IL LOGIN
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Favorite>(create: (_) => Favorite()),
        ChangeNotifierProvider<DistanceNotifier>(
            create: (_) => DistanceNotifier()),
        ChangeNotifierProvider<HeartRateNotifier>(
            create: (_) => HeartRateNotifier()),
      ],
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
          TrainingPage.routename: (context) => TrainingPage(),
        },
      ),
    );
  }
}
