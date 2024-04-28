import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:sustainable_moving/Models/items.dart';
import 'package:provider/provider.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({Key? key}) : super(key: key);

  static const routename = 'ChoosePage';

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int selectedIndex; // Track the index of the tapped item
  final Catalog catalog = Catalog(); // Define the catalog here

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    selectedIndex = -1; // Initialize selectedIndex to -1
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index; // Update selected index
    });
    _controller.forward(); // Start animation
  }

  void _addToFavorites(int index) {
    Provider.of<Favorite>(context, listen: false)
        .addProduct(catalog.items[index]);
  }

  void _showDescription(BuildContext context, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Description'),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 4 / 3,
              ),
              itemCount: catalog.items.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _handleTap(index), // Pass index to _handleTap
                  child: Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Image.asset(
                          catalog.items[index].imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    catalog.items[index].name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Length: ${catalog.items[index].length} km",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _addToFavorites(index);
                                      _controller.forward(
                                          from:
                                              0); // Start animation from the beginning
                                    },
                                    icon: Icon(Icons.favorite),
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showDescription(context,
                                          catalog.items[index].description);
                                      _controller.forward(
                                          from:
                                              0); // Start animation from the beginning
                                    },
                                    icon: Icon(Icons.info),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
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
