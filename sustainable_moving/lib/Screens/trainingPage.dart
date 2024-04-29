import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:sustainable_moving/Impact/impact.dart';
import 'package:sustainable_moving/Models/heartRate.dart';
import 'package:sustainable_moving/Models/heartRateNotifier.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  static const routename = 'trainingPage';

  @override
  _TrainingPage createState() => _TrainingPage();
}

class _TrainingPage extends State<TrainingPage> {
  bool _isCalendarVisible = false;
  String? _heartRate;
  HeartRateNotifier lista = HeartRateNotifier();
  final Random random = Random();
  String heartRateText = 'No data';
  final CountDownController _controller = CountDownController();
  int _duration = 0;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;

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
              FittedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: 9.0,
                          child: Icon(Icons.favorite, color: Colors.red),
                        ),
                        Column(
                          children: [
                            Consumer<HeartRateNotifier>(
                              builder: (context, heartRateNotifier, child) {
                                if (heartRateNotifier.pulses.isNotEmpty) {
                                  final randomIndex = Random()
                                      .nextInt(heartRateNotifier.pulses.length);
                                  final randomHeartRate = heartRateNotifier
                                      .pulses[randomIndex].value;

                                  return Text(
                                    randomHeartRate.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'No data',
                                    style: TextStyle(color: Colors.black),
                                  );
                                }
                              },
                            ),
                            Text(
                              "BPM",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(width: 90),
                    CircularCountDownTimer(
                      duration: _duration,
                      initialDuration: 0,
                      controller: _controller,
                      width: MediaQuery.of(context).size.width / 2.7,
                      height: MediaQuery.of(context).size.height / 2.7,
                      ringColor: Color.fromARGB(255, 247, 236, 137)!,
                      fillColor: Colors.orange!,
                      backgroundColor: Colors.red,
                      backgroundGradient: null,
                      strokeWidth: 30.0,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textFormat: CountdownTextFormat.MM_SS,
                      isReverse: false,
                      isReverseAnimation: false,
                      isTimerTextShown: true,
                      autoStart: false,
                    ),
                    //FFAFSA
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPickerLabel('Minutes'),
                      SizedBox(width: 10),
                      _buildDurationInput('Minutes', _selectedMinutes, (value) {
                        setState(() {
                          _selectedMinutes = int.tryParse(value) ?? 0;
                          _updateDuration();
                        });
                      }),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Column(
                    children: [
                      SizedBox(width: 50),
                      _buildPickerLabel('Seconds'),
                      SizedBox(width: 10),
                      _buildDurationInput('Seconds', _selectedSeconds, (value) {
                        setState(() {
                          _selectedSeconds = int.tryParse(value) ?? 0;
                          _updateDuration();
                        });
                      }),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(
                      title: "Start",
                      onPressed: () => _controller.restart(duration: _duration),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    _button(
                      title: "Pause",
                      onPressed: () => _controller.pause(),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    _button(
                      title: "Resume",
                      onPressed: () => _controller.resume(),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    _button(
                      title: "Restart",
                      onPressed: () => _controller.restart(duration: _duration),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              _showTotal(context);
                            },
                            icon: Icon(Icons.local_drink),
                            label: Text(
                              "Add Water",
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _consumeWater(context);
                            },
                            icon: Icon(Icons.local_drink_outlined),
                            label: Text(
                              "Consume Water",
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder(
                            future: SharedPreferences.getInstance(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final sp = snapshot.data!;
                                final tempCount = sp.getInt('counter');
                                final _total = tempCount ?? 0;
                                return Text(
                                  _total.toString(),
                                  style: TextStyle(fontSize: 24),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          Text(
                            "ml remaining",
                            style: TextStyle(fontSize: 24),
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

  Widget _button({required String title, VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPickerLabel(String label) {
    return Text(label);
  }

  Widget _buildDurationInput(
      String label, int value, Function(String) onChanged) {
    return SizedBox(
      width: 60,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _updateDuration() {
    setState(() {
      _duration = _selectedMinutes * 60 + _selectedSeconds;
    });
  }

  void _consumeWater(BuildContext context) {
    int number = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Number'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                number = int.tryParse(value) ?? 0;
              });
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final sp = await SharedPreferences.getInstance();
                final _total = sp.getInt('counter') ?? 0;
                if ((_total - number) >= 0) {
                  setState(() {
                    sp.setInt('counter', _total - number);
                  });
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
    int number = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Number'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                number = int.tryParse(value) ?? 0;
              });
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final sp = await SharedPreferences.getInstance();
                final _total = sp.getInt('counter') ?? 0;
                setState(() {
                  sp.setInt('counter', _total + number);
                });
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<int?> _authorize() async {
    final url = ImpactHR.baseUrl + ImpactHR.tokenEndpoint;
    final body = {'username': ImpactHR.username, 'password': ImpactHR.password};

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

  Future<List<HeartRate>?> _requestData() async {
    List<HeartRate>? result;

    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (JwtDecoder.isExpired(access!)) {
      await _refreshTokens();
      access = sp.getString('access');
    }

    final day = '2023-05-04';
    final url = ImpactHR.baseUrl +
        ImpactHR.hrEndpoint +
        ImpactHR.patientUsername +
        '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //print('Calling: $url');
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

  Future<int> _refreshTokens() async {
    final url = ImpactHR.baseUrl + ImpactHR.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

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

  Future<List<HeartRate>?> _getHeartRate() async {
    List<HeartRate>? heartRates = await _requestData();
    if (heartRates != null && heartRates.isNotEmpty) {
      setState(() {
        _heartRate = heartRates.first.value.toString();
      });
      heartRates.forEach((heartRate) {
        Provider.of<HeartRateNotifier>(context, listen: false)
            .addProduct(heartRate);
      });
    } else {
      print("Unable to fetch Heart Rate datas...");
    }
    return heartRates;
  }

  @override
  void initState() {
    super.initState();
    _authorize();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _getHeartRate();
      updateHeartRateText();
    });
  }

  void updateHeartRateText() {
    setState(() {
      if (Provider.of<HeartRateNotifier>(context, listen: false)
          .pulses
          .isNotEmpty) {
        final randomIndex = random.nextInt(
            Provider.of<HeartRateNotifier>(context, listen: false)
                .pulses
                .length);
        final randomHeartRate =
            Provider.of<HeartRateNotifier>(context, listen: false)
                .pulses[randomIndex]
                .value;
        heartRateText = randomHeartRate.toString();
      } else {
        heartRateText = 'No data';
      }
    });
  }
}
