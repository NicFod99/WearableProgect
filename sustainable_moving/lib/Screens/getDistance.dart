import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/distance.dart';
import 'package:sustainable_moving/Impact/impact.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sustainable_moving/Models/distanceNotifier.dart';

class GetDistanceFeature extends StatefulWidget {
  const GetDistanceFeature({Key? key}) : super(key: key);

  static const routename = 'getDistanceFeature';

  @override
  _GetDistanceFeatureState createState() => _GetDistanceFeatureState();
}

class _GetDistanceFeatureState extends State<GetDistanceFeature> {
  List<Distance> _distances = []; // List to hold distances
  double _totalDistance = 0;
  // Variable to hold the total distance

  @override
  Widget build(BuildContext context) {
    print('${GetDistanceFeature.routename} built');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Distance Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  final result = await _authorize();
                  final message =
                      result == 200 ? 'Request successful' : 'Request failed';
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                },
                child: Text('Authorize the app')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  await sp.remove('access');
                  await sp.remove('refresh');
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text('Tokens have been deleted')));
                },
                child: Text('Unauthorize the app')),
            ElevatedButton(
              onPressed: () async {
                final result = await _requestData();
                setState(() {
                  _distances = result ?? []; // Update the distances list
                  _totalDistance =
                      _calculateTotalDistance(); // Calculate the total distance
                });
              },
              child: Text('Distance'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Total Distance: ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _totalDistance.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " km",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.0),
            // Show distances in a ListView
            Expanded(
              child: ListView.builder(
                itemCount: _distances.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                        'Time: ${_distances[index].time}, Value: ${_distances[index].value}'),
                  );
                },
              ),
            ),
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  // Go back to the previous page
                  Navigator.popUntil(context, ModalRoute.withName('/home/'));
                },
                child: Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Calculate the total distance
  double _calculateTotalDistance() {
    double total = 0;
    for (var distance in _distances) {
      total += (distance.value / 1000);
    }
    return total;
  }

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int?> _authorize() async {
    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If 200, set the token
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_authorize

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<List<Distance>?> _requestData() async {
    // Get the stored access token
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access');

    // If the access token is expired, refresh it
    if (access != null && JwtDecoder.isExpired(access)) {
      await _refreshTokens();
    }

    // Create the request
    final day = '2023-05-04';
    final url =
        '${Impact.baseUrl}${Impact.distanceEndpoint}${Impact.patientUsername}/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    // Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    // Parse the response if it's OK, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final List<Distance> distances = [];
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        final distance = Distance.fromJson(decodedResponse['data']['date'],
            decodedResponse['data']['data'][i]);
        // Check if the value is greater than 0 before adding it to the result list
        if (distance.value > 0) {
          distances.add(distance);
          Provider.of<DistanceNotifier>(context, listen: false)
              .addProduct(distance);
          print(distance);
        }
      }
      return distances;
    } else {
      return null;
    }
  } //_requestData

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int> _refreshTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    //Get the respone
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If 200 set the tokens
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Return just the status code
    return response.statusCode;
  }
}
