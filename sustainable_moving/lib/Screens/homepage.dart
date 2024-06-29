import 'package:flutter/material.dart';
import 'package:sustainable_moving/Screens/loginPage.dart';

/* Pagine HomePage, ho voluto provare Image.Network, richiama un link dove c'è
 * la foto, ma potete anche scaricarla e aggiungerla negli assets, e poi richia
 * marla, come ho fatto nella linea 37. C'è una piccola animazione per l'intro. */

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'Sustainable Moving';

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background image covering the entire screen
            Image.asset(
              'assets/whiteHome.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              child: Center(
                child: Image.asset('assets/Logo.png'),
              ),
            ),

            // Positioned at the bottom
            Positioned(
              bottom: 40.0,
              left: 0,
              right: 0,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final fontSize = constraints.maxWidth * 0.045;
                    return TweenAnimationBuilder<double>(
                      // Animazione scritta.
                      tween: Tween<double>(begin: 1, end: 1.5),
                      duration: Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Text(
                            'Click anywhere to continue',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 58, 136, 61),
                              shadows: [
                                Shadow(
                                  blurRadius: 2.0,
                                  color: Colors.black.withOpacity(0.6),
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } //build
} //HomePage
