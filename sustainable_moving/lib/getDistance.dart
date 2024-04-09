import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sustainable_moving/PathChoosing.dart';
import 'package:sustainable_moving/profilePage.dart';

class GetDistanceFeature extends StatefulWidget {
  const GetDistanceFeature({Key? key}) : super(key: key);

  static const routename = 'getDistanceFeature';

  @override
  _GetDistanceFeatureState createState() => _GetDistanceFeatureState();
}

class _GetDistanceFeatureState extends State<GetDistanceFeature> {
  String distance = '';

  Future<void> _getDistance() async {
    // Perform GET request
    final response = await http.get(Uri.parse('your_api_endpoint'));

    if (response.statusCode == 200) {
      // Parse response JSON
      final jsonResponse = jsonDecode(response.body);
      final distanceData = jsonResponse['data'] as List;
      final firstEntry = distanceData.first;
      final time = firstEntry['time'];
      final value = firstEntry['value'];

      setState(() {
        distance = 'Time: $time\nDistance: $value'; // Update the distance
      });
    } else {
      setState(() {
        distance = 'Failed to get distance'; // Update the distance
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('${GetDistanceFeature.routename} built');

    return Scaffold(
      appBar: AppBar(
        title: Text(GetDistanceFeature.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              distance.isNotEmpty
                  ? distance
                  : 'Distance will be displayed here',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _getDistance,
              child: Text('Get distance'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Go back to the previous page
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.roundabout_left),
            label: 'Path',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigate to the "PathChoosing" page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PathChoosingFeature()),
            );
          }
          if (index == 1) {
            // Navigate to the "PathChoosing" page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
          if (index == 2) {
            // Navigate to the "PathChoosing" page
            print("TODO");
          }
        },
      ),
    );
  }
}
