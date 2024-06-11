import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/items.dart';

/* NOTIFIER DI FAVORITE, aggiungere qui le funzioni per ottimizzare il codice
 * (vedi Heart Rate Notifier), è un notifier fatto ad hoc per la pagina favorite
 * */

class Favorite extends ChangeNotifier {
  // For simplicity, a product is just a String.
  List<PathData> products = [];

  // Method to add a product to the list
  void addProduct(PathData product) {
    if (!products.contains(product)) {
      products.add(product);
      notifyListeners();
    }
  }

  // Method to remove a product from the list
  void removeProduct(PathData product) {
    if (products.contains(product)) {
      products.remove(product);
      notifyListeners();
    }
  }

  void clearFavorite() {
    products.clear();
    // Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  }

  bool isFavorite(PathData product) {
    return products.contains(product);
  }
}
