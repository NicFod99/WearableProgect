import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainable_moving/Models/favorite.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  static const routename = 'Favoritepage';

  @override
  Widget build(BuildContext context) {
    print('${FavoritePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        actions: [
          //Here, we only need to set the action to perform after the button is pressed. So, it is not necessary to use a Consumer.
          //This approach won't cause the IconButton widget to rebuild when the notifyListeners() method is called.
          IconButton(
              onPressed: () =>
                  Provider.of<Favorite>(context, listen: false).clearFavorite(),
              icon: Icon(Icons.delete))
        ],
        centerTitle: true,
        title: Text("Favorite places"),
      ),
      body: Center(
        //On the other hand, here we need a Consumer, since we want the UI to update if the notifyListeners() method is called
        // for example, after the tap of the IconButton in the AppBar.
        child: Consumer<Favorite>(
          builder: (context, favorite, child) {
            return Text(
                'You have ${favorite.favorites.length} favorite places.');
          },
        ),
      ),
    );
  } //build
} //CartPage
