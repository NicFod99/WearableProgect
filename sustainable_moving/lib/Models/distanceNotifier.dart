import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustainable_moving/Models/distance.dart';
import 'package:sustainable_moving/Impact/impact.dart';
import 'package:logger/logger.dart';
import 'package:sustainable_moving/utils/authorize_utils.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// DistanceNotifier class extends ChangeNotifier to provide notification to its listeners when a change occurs
class DistanceNotifier extends ChangeNotifier {
  // Initialize the logger
  var logger = Logger();
  // List to store distances
  List<Distance> distances = [];

  // Method to add a distance to the list
  void addProduct(Distance product) {
    distances.add(product);
    notifyListeners();
  }

  // Method to clear all distances
  void clearFavorite() {
    distances.clear();
    notifyListeners();
  }

  // Method to get the distance
  Future<void> getDistance() async {
    // Request the data
    List<Distance>? distance = await _requestData('2023-05-04');
    // If the data is not null and not empty, update the distances
    if (distance != null && distance.isNotEmpty) {
      distances = distance;
    } else {
      // Log the error message
      logger.e("Unable to fetch Distance data...");
    }
    // Notify all the listeners about this update
    notifyListeners();
  }

  // Method to request the data
  Future<List<Distance>?> _requestData(String day) async {
    List<Distance>? result;
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access != null && JwtDecoder.isExpired(access)) {
      await AuthorizeUtils.refreshTokens();
      access = sp.getString('access');
    }

    final url =
        '${Impact.baseUrl}${Impact.distanceEndpoint}${Impact.patientUsername}/day/$day/';

    // Send the GET request
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $access'},
      );

      // If the response is successful, parse the data
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        result = [];
        for (var item in decodedResponse['data']['data']) {
          result.add(Distance.fromJson(decodedResponse['data']['date'], item));
        }
      } else {
        result = null;
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      result = null;
    } on http.ClientException catch (e) {
      print('Client error: $e');
      result = null;
    } catch (e) {
      print('An unexpected error occurred: $e');
      result = null;
    }

    return result;
  }

  Future<List<Distance>?> fetchData(String day) async {
    return _requestData(day);
  }

  // Method to pick the data
  List<int> _dataPicker() {
    // Map the distances to their integer values and take the first 5
    List<int> distanceList = distances.map((e) => e.value.toInt()).toList();
    return distanceList.take(5).toList();
  }
}
