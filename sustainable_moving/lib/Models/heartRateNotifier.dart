import 'dart:convert';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustainable_moving/Models/heartRate.dart';
import 'package:sustainable_moving/Impact/impact.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:sustainable_moving/utils/authorize_utils.dart';

/* NOTIFIER DI DISTANCE, aggiungere qui le funzioni per ottimizzare il codice
 * il codice delle get è stato fatto qui per ottimizzare (dovrebbe ottimizzare)
 * */

final List<Feature> features = [
  Feature(title: "BPM", color: Colors.red, data: []),
  Feature(
    title: "Water",
    color: Colors.blue,
    data: [1, 0.8, 0.6, 0.7, 0.3],
  ),
];

class HeartRateNotifier extends ChangeNotifier {
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
  }

  /*Future<List<HeartRate>?> getHeartRate() async {
    List<HeartRate>? heartRates = await _requestData();
    if (heartRates != null && heartRates.isNotEmpty) {
      pulses = heartRates;
    } else {
      print("Unable to fetch Heart Rate datas...");
    }
    notifyListeners();
  }*/

  Future<List<HeartRate>?> _requestData() async {
    List<HeartRate>? result;

    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access != null && JwtDecoder.isExpired(access)) {
      await AuthorizeUtils.refreshTokens();
      access = sp.getString('access');
    }

    const day = '2023-05-04';
    final url =
        '${Impact.baseUrl}${Impact.hrEndpoint}${Impact.patientUsername}/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      result = [];
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        result.add(HeartRate.fromJson(decodedResponse['data']['date'],
            decodedResponse['data']['data'][i]));
      }
    } else {
      result = null;
    }

    return result;
  }

  Future<List<HeartRate>?> fetchData() async {
    return _requestData();
  }


  List<double> _dataPicker() {
    List<double> heartRatetoList =
        pulses.map((e) => e.value.toDouble()).toList();
    return heartRatetoList.take(5).toList();
  } //clearCart
}//Cart
