// Importing necessary libraries
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustainable_moving/Models/distance.dart';
import 'package:sustainable_moving/Impact/impact.dart';
import 'package:logger/logger.dart';

// DistanceNotifier class extends ChangeNotifier to provide notification to its listeners when a change occurs
class DistanceNotifier extends ChangeNotifier {
  // Initialize the logger
  var logger = Logger();
  // List to store distances
  List<Distance> distances = [];

  // Method to add a distance to the list
  void addProduct(Distance product) {
    distances.add(product);
    // Notify all the listeners about this update
    notifyListeners();
  }

  // Method to clear all distances
  void clearFavorite() {
    distances.clear();
    // Notify all the listeners about this update
    notifyListeners();
  }

  // Method to authorize the user
  Future<int?> authorize() async {
    // Prepare the URL and body for the POST request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    // Send the POST request
    final response = await http.post(Uri.parse(url), body: body);

    // If the response is successful, save the access and refresh tokens
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    }

    // Return the status code of the response
    return response.statusCode;
  }

  // Method to refresh the tokens
  Future<int> refreshTokens() async {
    // Prepare the URL and body for the POST request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    // Send the POST request
    final response = await http.post(Uri.parse(url), body: body);

    // If the response is successful, update the access and refresh tokens
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    }

    // Return the status code of the response
    return response.statusCode;
  }

  // Method to get the distance
  Future<void> getDistance() async {
    // Request the data
    List<Distance>? distance = await _requestData();
    // If the data is not null and not empty, update the distances
    if (distance != null && distance.isNotEmpty) {
      distances = distance;
    } else {
      // Log the error message
      logger.e("Unable to fetch Distance datas...");
    }
    // Notify all the listeners about this update
    notifyListeners();
  }

  // Method to request the data
  Future<List<Distance>?> _requestData() async {
    List<Distance>? result;
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access');
    const day = '2023-05-04';
    final url = '${Impact.baseUrl}${Impact.distanceEndpoint}${Impact.patientUsername}/day/$day/';

    // Send the GET request
    final response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $access',
    });

    // If the response is successful, parse the data
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      result = [];
      for (var item in decodedResponse['data']['data']) {
        result.add(Distance.fromJson(decodedResponse['data']['date'],item));
      }
    } else {
      result = null;
    }

    // Return the result
    return result;
  }

  // Method to pick the data
  List<int> _dataPicker() {
    // Map the distances to their integer values and take the first 5
    List<int> distanceList = distances.map((e) => e.value.toInt()).toList();
    return distanceList.take(5).toList();
  } 
}