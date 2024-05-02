import 'package:flutter/material.dart';
import 'package:sustainable_moving/Screens/getDistance.dart';
import 'package:sustainable_moving/Screens/trainingPage.dart';

/* TODO EDIT PROFILE Si dovrebbe fare, anche se non è obbligatorio, non saprei
 * neanche cosa metterci, però vedete se avete idee */

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  static const routename = 'EditProfilePage';
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          TrainingPage(),
          GetDistanceFeature(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int newindex) {
          setState(() {
            index = newindex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
    );
  } //build
} //HomePage