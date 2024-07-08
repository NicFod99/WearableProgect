import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sustainable_moving/Models/distanceNotifier.dart';
import 'package:sustainable_moving/Models/heartRateNotifier.dart';
import 'package:sustainable_moving/Screens/PathChoosing.dart';
import 'package:sustainable_moving/Screens/editProfile.dart';
import 'package:sustainable_moving/Screens/home.dart';
import 'package:sustainable_moving/Screens/navBar.dart';
import 'package:sustainable_moving/Screens/homepage.dart';
import 'package:sustainable_moving/Screens/loginPage.dart';
import 'package:sustainable_moving/Screens/trainingPage.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const SustainableMovingApp());
}

/* MAIN, ci sono 3 provider, Heart e Distance fanno una get e prelevano roba. 
 * Se volete aggiungere provider per altri get, richiamateli come qui.
 * Non c'è bisogno di aggiungere le pagine qui. */

class SustainableMovingApp extends StatelessWidget {
  const SustainableMovingApp({super.key});
  // WRAPPARE IN A FUTUREBUILDER PER IL LOGIN,
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
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFD4EED8),
          appBarTheme: AppBarTheme(
              backgroundColor:
                  Color(0xFFD4EED8) // Match app bar background color
              ), // Global background color
        ),
        initialRoute:
            HomePage // <- CAMBIA QUA PER LAVORARE DIRETTAMENTE SU UNA PAGINA
                .routename,
        routes: {
          HomePage.routename: (context) => const HomePage(),
          NavBar.routename: (context) => const NavBar(),
          ChoosePage.routename: (context) => const ChoosePage(),
          PathChoosingFeature.routename: (context) =>
              const PathChoosingFeature(),
          LoginPage.routename: (context) => const LoginPage(),
          EditProfile.routename: (context) => const EditProfile(),
          TrainingPage.routename: (context) => const TrainingPage(),
        },
      ),
    );
  }
}
