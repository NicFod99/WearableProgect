import 'package:flutter/material.dart';
import 'package:sustainable_moving/home.dart';
import 'package:sustainable_moving/loginPage.dart';
import 'package:sustainable_moving/editProfile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const routename = 'Profilepage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(ProfilePage.routename),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              child: const Text('To the Edit'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditPage()));
              },
            ),
            ElevatedButton(
              child: const Text('To the homepage'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )));
  } //build
} //HomePage