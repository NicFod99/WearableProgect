import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sustainable_moving/Impact/impact.dart';
import 'package:sustainable_moving/Models/heartRate.dart';
import 'package:sustainable_moving/Models/heartRateNotifier.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  static const routename = 'trainingPage';

  @override
  _TrainingPage createState() => _TrainingPage();
}

class _TrainingPage extends State<TrainingPage> {
  int _timer = 0;
  int _total = 0;
  bool _isCalendarVisible = false;
  String? _heartRate; // Define _heartRate variable
  HeartRateNotifier lista = HeartRateNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Training Page"),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                onPressed: () {
                  _getHeartRate();
                  // Call function to get heart rate
                },
                child: Text("Get HeartRate"),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isCalendarVisible = !_isCalendarVisible;
                  });
                },
                child: Text(
                  "${DateTime.now().toString().substring(0, 10)}",
                  style: TextStyle(fontSize: 25, color: Colors.blue),
                ),
              ),
              if (_isCalendarVisible)
                SfDateRangePicker(
                  view: DateRangePickerView.month,
                  monthViewSettings: const DateRangePickerMonthViewSettings(
                    showWeekNumber: true,
                    weekNumberStyle: DateRangePickerWeekNumberStyle(
                      textStyle: TextStyle(fontStyle: FontStyle.italic),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              SizedBox(height: 100),
              Stack(
                children: [
                  SizedBox(width: 150),
                  Transform.scale(
                    scale: 10.0, // Adjust the scale factor as needed
                    child: Icon(Icons.favorite),
                  ),
                  Consumer<HeartRateNotifier>(
                    builder: (context, mealDB, child) {
                      //If the list of meals is empty, show a simple Text, otherwise show the list of meals using a ListView.
                      return mealDB.pulses.isEmpty
                          ? Text('Empty')
                          : ListView.builder(
                              itemCount: mealDB.pulses.length,
                              itemBuilder: (context, mealIndex) {
                                Text(
                                  "C'è roba",
                                  style: TextStyle(color: Colors.black),
                                );
                              });
                    },
                  ),
                ],
              ),
              SizedBox(height: 150),
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              _showTotal(context);
                            },
                            icon: Icon(Icons.local_drink), // Icon on the left
                            label: Text(
                              "Add Water",
                              style: TextStyle(
                                fontSize: 19, // Adjust the font size as needed
                              ),
                            ), // Button label
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24), // Adjust padding as needed
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ), // Add some spacing between the button and text field
                          ElevatedButton.icon(
                            onPressed: () {
                              _consumeWater(context);
                            },
                            icon: Icon(
                                Icons.local_drink_outlined), // Icon on the left
                            label: Text(
                              "Consume Water",
                              style: TextStyle(
                                fontSize: 19, // Adjust the font size as needed
                              ),
                            ), // Button label
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24), // Adjust padding as needed
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ), // Add some spacing between the button and text field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder(
                            future: SharedPreferences.getInstance(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final sp = snapshot.data!;
                                final tempCount = sp.getInt('counter');
                                if (tempCount == null) {
                                  _total = 0;
                                } else {
                                  _total = tempCount;
                                }
                                return Text(
                                  _total.toString(),
                                  style: TextStyle(
                                    fontSize:
                                        24, // Adjust the font size as needed
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          Text(
                            "ml remaining",
                            style: TextStyle(
                              fontSize: 24, // Adjust the font size as needed
                            ),
                          ),
                        ],
                      ),
                      // Text field to display the total
                    ],
                  ),
                  SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _startTimer(context);
                                },
                                icon: Icon(Icons.timer), // Icon on the left
                                label: Text(
                                  "Set Timer",
                                  style: TextStyle(
                                    fontSize:
                                        20, // Adjust the font size as needed
                                  ),
                                ), // Button label
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal:
                                          24), // Adjust padding as needed
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Add some spacing between the button and text field
                              ElevatedButton.icon(
                                onPressed: () {
                                  _resetTimer();
                                },
                                icon: Icon(Icons.restore), // Icon on the left
                                label: Text(
                                  "Reset Timer",
                                  style: TextStyle(
                                    fontSize:
                                        20, // Adjust the font size as needed
                                  ),
                                ), // Button label
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal:
                                          24), // Adjust padding as needed
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ), // Add some spacing between the button and text field
                          Text(
                            _formatTime(_timer),
                            style: TextStyle(
                              fontSize: 24, // Adjust the font size as needed
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetTimer() {
    setState(() {
      _timer = 0; // Reset the timer to zero
    });
  }

  void _consumeWater(BuildContext context) {
    // Implement the functionality to add a number and show the total
    int number = 0; // Initialize the number variable
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Number'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Update the number variable as the user types
              setState(() {
                number = int.tryParse(value) ?? 0;
              });
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Add the new number to the existing total
                if ((_total - number) >= 0) {
                  setState(() {
                    _total -= number;
                  });
                  final sp = await SharedPreferences.getInstance();
                  await sp.setInt('counter', _total);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showTotal(BuildContext context) {
    // Implement the functionality to add a number and show the total
    int number = 0; // Initialize the number variable
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Number'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Update the number variable as the user types
              setState(() {
                number = int.tryParse(value) ?? 0;
              });
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Add the new number to the existing total
                setState(() {
                  _total += number;
                });
                final sp = await SharedPreferences.getInstance();
                await sp.setInt('counter', _total);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _startTimer(BuildContext context) {
    // Implement the functionality to set a timer
    int duration = 60; // Initial duration in seconds
    int remainingTime =
        duration * 100; // Initialize remaining time in centiseconds

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Timer'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Update the duration variable as the user types
              setState(() {
                //duration = int.tryParse(value) ?? 0;
                //remainingTime = duration * 100;
              });
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Start the timer
                Timer.periodic(Duration(milliseconds: 10), (Timer timer) {
                  setState(() {
                    if (remainingTime == 0) {
                      timer.cancel(); // Stop the timer when it reaches zero
                    } else {
                      remainingTime -=
                          1; // Decrement remaining time by 1 centisecond
                      _timer = remainingTime; // Update timer variable
                    }
                  });
                });
              },
              child: Text('Start Timer'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int time) {
    int seconds = time ~/ 100; // Calculate seconds
    int centiseconds = time % 100; // Calculate centiseconds
    return '$seconds:$centiseconds'; // Return formatted time
  }

  Future<int?> _authorize() async {
    //Create the request
    final url = ImpactHR.baseUrl + ImpactHR.tokenEndpoint;
    final body = {'username': ImpactHR.username, 'password': ImpactHR.password};

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
  Future<List<HeartRate>?> _requestData() async {
    //Initialize the result
    List<HeartRate>? result;

    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    //If access token is expired, refresh it
    if (JwtDecoder.isExpired(access!)) {
      await _refreshTokens();
      access = sp.getString('access');
    } else {
      print("Unable to fetch Heart Rate datas...");
    } //if

    //Create the (representative) request
    final day = '2023-05-04';
    final url = ImpactHR.baseUrl +
        ImpactHR.hrEndpoint +
        ImpactHR.patientUsername +
        '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      result = [];
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        print("ok");
        /*result.add(HeartRate.fromJson(decodedResponse['data']['date'],
            decodedResponse['data']['data'][i]));
      */
      } //for
    } //if
    else {
      result = null;
    } //else

    //Return the result
    return result;
  } //_requestData

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int> _refreshTokens() async {
    //Create the request
    final url = ImpactHR.baseUrl + ImpactHR.refreshEndpoint;
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

  Future<List<HeartRate>?> _getHeartRate() async {
    List<HeartRate>? heartRates = await _requestData();
    if (heartRates != null && heartRates.isNotEmpty) {
      setState(() {
        _heartRate =
            heartRates.first.value.toString(); // Update heart rate value
      });

      // Print each heart rate value in the console
      print("Heart Rates:");
      heartRates.forEach((heartRate) {
        Provider.of<HeartRateNotifier>(context, listen: false)
            .addProduct(heartRate);
        print(
            "Time: ${heartRate.time}, Value: ${heartRate.value}, Confidence: ${heartRate.confidence}");
      });
    } else {
      print("Unable to fetch Heart Rate datas...");
    }
    return heartRates;
  }
}
