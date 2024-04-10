import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});
  static const routename = 'Editpage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(EditPage.routename),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              child: const Text('To the profile'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )));
  } //build
} //HomePage