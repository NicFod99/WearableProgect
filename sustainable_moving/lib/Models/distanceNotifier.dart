import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/distance.dart';

/* NOTIFIER DI DISTANCE, aggiungere qui le funzioni per ottimizzare il codice
 * (vedi Heart Rate Notifier) */

class DistanceNotifier extends ChangeNotifier {
  //For simplicity, a product is just a String.
  List<Distance> distances = [];
  // Method to add a product to the list
  void addProduct(Distance product) {
    distances.add(product);
    notifyListeners();
  } //addProduct

  void clearFavorite() {
    distances.clear();
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  } //clearCart
}//Cart