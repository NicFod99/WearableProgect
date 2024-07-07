import 'package:flutter/material.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
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
            Image.asset('assets/background.jpg'),

            // Container bianco che copre l'intero schermo
            Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              child: Center(
                child: Image.asset('assets/LogoClean.png'),
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
                          child: const Text(
                            'Click anywhere \nto continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: Color.fromARGB(255, 47, 125, 49),
                              height: 1.1,
                              /*shadows: [
                                Shadow(
                                  blurRadius: 2.0,
                                  color: Colors.black.withOpacity(0.6),
                                  offset: Offset(0, 2),
                                ),
                              ],*/
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
