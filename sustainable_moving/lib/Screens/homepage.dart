import 'package:flutter/material.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:sustainable_moving/Screens/loginPage.dart';

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
            // Background Image
            Image.asset(
              'assets/backgroundNew.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            // White container overlay
            Container(
              //color: Colors.white.withOpacity(0.6), // Adjust opacity as needed
              width: double.infinity,
              height: double.infinity,
            ),

            // Logo in the center with scaling
            Positioned(
              top: 70.0, // Adjust position as needed
              left: 0,
              right: 0,
              child: Center(
                child: Transform.scale(
                  scale: 1.6, // Adjust the scale factor as needed
                  child: Image.asset(
                    'assets/LogoClean.png',
                    width: 200, // Adjust size as needed
                  ),
                ),
              ),
            ),

            // Text at the bottom
            Positioned(
              bottom: 40.0,
              left: 0,
              right: 0,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final fontSize = constraints.maxWidth * 0.045;
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 1, end: 1.5),
                      duration: Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Text(
                            'Click anywhere \nto continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: Color.fromARGB(255, 255, 255, 255),
                              height: 1.1,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  offset: Offset(0, 0),
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
  }
}
