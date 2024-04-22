import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/items.dart';

//THis class extends ChangeNotifier. It will act as data repository to be shared thorugh the application.
class Favorite extends ChangeNotifier {
  //For simplicity, a product is just a String.
  List<PathData> products = [];
  // Method to add a product to the list
  void addProduct(PathData product) {
    products.add(product);
    notifyListeners();
  } //addProduct

  void clearFavorite() {
    products.clear();
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  } //clearCart
}//Cart
