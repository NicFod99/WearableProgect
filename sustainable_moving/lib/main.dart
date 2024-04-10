import 'package:flutter/material.dart';
import 'package:sustainable_moving/Screens/PathChoosing.dart';
import 'package:sustainable_moving/Screens/editProfile.dart';
import 'package:sustainable_moving/Screens/getDistance.dart';
import 'package:sustainable_moving/Screens/home.dart';
import 'package:sustainable_moving/Screens/homepage.dart';
import 'package:sustainable_moving/Screens/loginPage.dart';
import 'package:sustainable_moving/Screens/profilePage.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Sustainable Moving",
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/distance/': (context) => const GetDistanceFeature(),
        '/home/': (context) => const ChoosePage(),
        '/path/': (context) => PathChoosingFeature(),
        '/login/': (context) => const LoginPage(),
        '/editpage/': (context) => const EditPage(),
        '/profilepage/': (context) => const ProfilePage(),
      },
    ),
  );
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This specifies the app entrypoint
      home: HomePage(),
    );
  } //build
}//MyApp

