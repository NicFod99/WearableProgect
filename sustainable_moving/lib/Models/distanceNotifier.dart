import 'dart:convert';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';
//import 'package:sustainable_moving/Models/featuresGraph.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustainable_moving/Models/distance.dart';
import 'package:sustainable_moving/Impact/impact.dart';
import 'package:draw_graph/models/feature.dart';

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
  }

  Future<int?> authorize() async {
    final url = Impact.baseUrl + Impact.tokenEndpoint;

    final body = {'username': Impact.username, 'password': Impact.password};

    //print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    }

    return response.statusCode;
  }

  Future<int> refreshTokens() async {
    final url = ImpactHR.baseUrl + ImpactHR.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    }

    return response.statusCode;
  }

  Future<void> getDistance() async {
    List<Distance>? distance = await _requestData();
    if (distance != null && distance.isNotEmpty) {
      distances = distance;
    } else {
      print("Unable to fetch Distance datas...");
    }
    notifyListeners();
  }

  Future<List<Distance>?> _requestData() async {
    List<Distance>? result;
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access');
    //final day = DateTime.now().day;
    final day = '2023-05-04';
    final url = '${Impact.baseUrl}${Impact.distanceEndpoint}${Impact.patientUsername}/day/$day/';
    ;
    final response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $access',
    });

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      result = [];
      for (var item in decodedResponse['data']['data']) {
        result.add(Distance.fromJson(decodedResponse['data']['date'],item));
      }
    } else {
      result = null;
    }

    return result;
  }

  List<double> _dataPicker() {
    List<double> distanceList =
        distances.map((e) => e.value.toDouble()).toList();
    return distanceList.take(5).toList();
  } 

}//Cart