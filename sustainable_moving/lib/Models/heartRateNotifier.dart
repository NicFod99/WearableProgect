import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/heartRate.dart';

//THis class extends ChangeNotifier. It will act as data repository to be shared thorugh the application.
class HeartRateNotifier extends ChangeNotifier {
  //For simplicity, a product is just a String.
  List<HeartRate> pulses = [];
  // Method to add a product to the list
  void addProduct(HeartRate product) {
    pulses.add(product);
    notifyListeners();
  } //addProduct

  void clearFavorite() {
    pulses.clear();
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  } //clearCart
}//Cart
