import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:sustainable_moving/Screens/home.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  static const routename = 'Favoritepage';

  @override
  Widget build(BuildContext context) {
    print('${FavoritePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
                Provider.of<Favorite>(context, listen: false).clearFavorite(),
            icon: Icon(Icons.delete),
          )
        ],
        centerTitle: true,
        title: Text("Favorite places"),
      ),
      body: Consumer<Favorite>(
        builder: (context, favorite, child) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 0.75,
            ),
            itemCount: favorite.favorites.length,
            itemBuilder: (BuildContext context, int index) {
              // Get the corresponding PathData object from the imageText list
              PathData pathData = imageText[index].name;
              return Column(
                children: [
                  Image.asset(
                    favorite.favorites[
                        index], // Assuming favorites contain image paths
                    fit: BoxFit.cover,
                  ),
                  Text(
                    pathData.name, // Display the name from the PathData object
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    pathData
                        .description, // Display the description from the PathData object
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
