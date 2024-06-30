import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:sustainable_moving/Models/items.dart';

/* Pagine Favorite, prende dal listato item e aggiunge tramite item builder ciò
 * che è presente nella lista item del provider Favorite */

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  static const routename = 'Favoritepage';

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
                  Text('$length km'),
                ],
              ),
            ],
          ),
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
    print('${FavoritePage.routename} built');
    final item = Provider.of<Favorite>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => item.clearFavorite(),
            icon: const Icon(Icons.delete),
          )
        ],
        centerTitle: true,
        title: const Text(
          "Favorite places",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
        ),
      ),
      body: ListView.builder(
        itemCount: item.products.length,
        itemBuilder: (BuildContext context, int index) {
          PathData pathData = item.products[index];

          return GestureDetector(
            onTap: () => _showDescription(
              context,
              pathData.name,
              pathData.description,
              pathData.length,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      pathData.imagePath,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pathData.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Length: ${pathData.length} m",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
