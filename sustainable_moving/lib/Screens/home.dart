import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:sustainable_moving/Models/items.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  static const routename = 'ChoosePage';

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int selectedIndex; // Track the index of the tapped item
  final Catalog catalog = Catalog(); // Define the catalog here
  late List<bool> _isFavorite; // Tracks the favorite status of each item

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
    _isFavorite = List<bool>.filled(catalog.items.length,
        false); // Initialize all elements as non-favorites

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Favorite>(context, listen: false)
          .addListener(_updateFavorites);
      _updateFavorites(); // Assicurarsi che _isFavorite sia inizializzato correttamente
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    Provider.of<Favorite>(context, listen: false)
        .removeListener(_updateFavorites);
    super.dispose();
  }

  void _updateFavorites() {
    final favorites = Provider.of<Favorite>(context, listen: false);
    setState(() {
      for (int i = 0; i < catalog.items.length; i++) {
        _isFavorite[i] = favorites.isFavorite(catalog.items[i]);
      }
    });
  }

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index; // Update selected index
    });
    _controller.forward(); // Start animation
    _showDescription(
        context,
        catalog.items[index].name,
        catalog.items[index].description,
        catalog.items[index].length); // Show description and length on tap
  }

  void _addToFavorites(int index) {
    setState(() {
      if (_isFavorite[index]) {
        _isFavorite[index] = false;
        Provider.of<Favorite>(context, listen: false)
            .removeProduct(catalog.items[index]);
      } else {
        _isFavorite[index] = true;
        Provider.of<Favorite>(context, listen: false)
            .addProduct(catalog.items[index]);
      }
    });
  }

  void _showDescription(
      BuildContext context, String name, String description, double length) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Length: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('$length m'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _openMap(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Welcome back Runner!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            )),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Destination Nearby",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 4 / 3,
              ),
              itemCount: catalog.items.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _handleTap(index),
                  child: Stack(
                    children: [
                      SizedBox(
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
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    catalog.items[index].name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Length: ${catalog.items[index].length} m",
                                    style: const TextStyle(
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
                                      _controller.forward(from: 0);
                                    },
                                    icon: Icon(Icons.favorite),
                                    color: _isFavorite[index]
                                        ? Colors.red
                                        : Colors.white,
                                    tooltip: 'Add to Favorites',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _openMap(catalog.items[index].mapUrl);
                                    },
                                    icon: Icon(Icons.map),
                                    color: Colors.white,
                                    tooltip: 'Open Map',
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
