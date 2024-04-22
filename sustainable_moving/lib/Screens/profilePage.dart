import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 12.0, right: 12.0, top: 60, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text("Info about you and your preferences",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Account",
              style: TextStyle(fontSize: 16),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Text(
                    "Personal Info",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: const Icon(Icons.navigate_next),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Sustainable moving aim to allow you to choose a better and sustainable path. Every use external from the Unipd enviroment its sanctioned by copyright. Work done by Quasi Ingegneri team.",
                    style: TextStyle(
                        fontSize: 14, color: Colors.black.withOpacity(0.4)),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text("version alpha 1.0.0"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
