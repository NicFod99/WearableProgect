import 'package:flutter/material.dart';
import 'package:sustainable_moving/PathChoosing.dart';
import 'package:sustainable_moving/home.dart';
import 'package:sustainable_moving/loginPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'Sustainable Moving';

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return GestureDetector(
      onTap: () {
        Navigator.push(
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
            Image.network(
              'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-4.0.3',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Positioned at the bottom
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final fontSize = constraints.maxWidth * 0.05;
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 1, end: 1.5),
                      duration: Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Text(
                            'Click anywhere to continue',
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.white, // Text color is white
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
