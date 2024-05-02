import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:sustainable_moving/Models/items.dart';

/* Pagine Favorite, prende dal listato item e aggiunge tramite item builder ciò
 * che è presente nella lista item del provider Favorite */

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  static const routename = 'Favoritepage';

  @override
  Widget build(BuildContext context) {
    print('${FavoritePage.routename} built');
    final item = Provider.of<Favorite>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => item.clearFavorite(),
            icon: Icon(Icons.delete),
          )
        ],
        centerTitle: true,
        title: Text("Favorite places"),
      ),
      body: ListView.builder(
        itemCount: item.products.length,
        itemBuilder: (BuildContext context, int index) {
          PathData pathData = item.products[index];

          return Column(
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Length: ${pathData.length} km",
                            style: TextStyle(
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
          );
        },
      ),
    );
  }
}
