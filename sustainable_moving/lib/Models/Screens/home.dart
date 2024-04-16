import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({Key? key}) : super(key: key);

  static const routename = 'ChoosePage';

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  static const List<String> imagePaths = [
    'assets/Pd1.jpg',
    'assets/Pd2.jpg',
    'assets/Pd3.jpg',
    'assets/Pd4.jpg',
    'assets/Pd5.jpg',
    // Add more image paths as needed
  ];

  late Timer _timer;
  List<bool> selected = List.filled(imagePaths.length, false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('${ChoosePage.routename} built');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome back Runner!"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Destination Nearby",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 0.75,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected[index] = !selected[index];
                    });
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                      ),
                      if (selected[index])
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
