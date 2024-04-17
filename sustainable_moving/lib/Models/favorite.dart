import 'package:flutter/material.dart';

//THis class extends ChangeNotifier. It will act as data repository to be shared thorugh the application.
class Favorite extends ChangeNotifier {
  //For simplicity, a product is just a String.
  List<String> favorites = [];

  void addProduct(String imaginePath) {
    favorites.add(imaginePath);
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  } //addProduct

  void clearFavorite() {
    favorites.clear();
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  } //clearCart
}//Cart