import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sustainable_moving/Models/heartRate.dart';
import 'package:sustainable_moving/Models/heartRateNotifier.dart';
import 'package:sustainable_moving/Models/distance.dart';
import 'package:sustainable_moving/Models/distanceNotifier.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:water_bottle/water_bottle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  static const routename = 'trainingPage';

  @override
  _TrainingPage createState() => _TrainingPage();
}

class _TrainingPage extends State<TrainingPage> {
  String today = '2023-05-04';
  List pulses = [];
  List todayDistances = [];
  double _todayDistance = 0.0;
  List weeklyDistances = [];
  List weeklyDistancesGraph = [];
  double weeklyDistanceMean = 0.0;
  double _distanceGoal = 5.0; // Default goal
  final Random random = Random();
  String heartRateText = 'No data';
  final CountDownController _controller = CountDownController();
  int _duration = 0;
  int _selectedHours = 0;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;
  DateTime time = DateTime.now();
  final plainBottleRef = GlobalKey<WaterBottleState>();
  final sphereBottleRef = GlobalKey<SphericalBottleState>();
  final triangleBottleRef = GlobalKey<TriangularBottleState>();
  var waterLevel = 0.5;
  var selectedStyle = 0;
  int _waterIntake = 0; // In half-liters
  double _userWeight = 0.0;
  double _waterGoal = 0.0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      getHeartRate();
      getDistance();
      getWeeklyDistanceMean();
      _checkPersonalInfoDeletion();
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      updateHeartRateText();
      getUserWeight();
    });

    _loadDistanceGoal();
  }

  Future<void> _loadDistanceGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _distanceGoal = prefs.getDouble('distanceGoal') ?? 5.0;
    });
  }

  Future<void> _saveDistanceGoal(double goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('distanceGoal', goal);
  }

  void _updateDistanceGoal(double goal) {
    setState(() {
      _distanceGoal = goal;
    });
    _saveDistanceGoal(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Activity",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                // ROW DEL CUORE E DEL TIMER
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: 9.0,
                          child: const Icon(Icons.favorite, color: Colors.red),
                        ),
                        Column(
                          children: [
                            Text(
                              pulses.isNotEmpty
                                  ? getRandomHeartRate()
                                  : 'No data',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
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
                    const SizedBox(width: 90),
                    CircularCountDownTimer(
                      duration: _duration,
                      initialDuration: 0,
                      controller: _controller,
                      width: MediaQuery.of(context).size.width / 2.7,
                      height: MediaQuery.of(context).size.height / 2.7,
                      ringColor: const Color.fromARGB(255, 247, 236, 137),
                      fillColor: Colors.orange,
                      backgroundColor: Colors.red,
                      backgroundGradient: null,
                      strokeWidth: 30.0,
                      strokeCap: StrokeCap.round,
                      textStyle: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textFormat: CountdownTextFormat.HH_MM_SS,
                      isReverse: true,
                      isReverseAnimation: false,
                      isTimerTextShown: true,
                      autoStart: false,
                    ),
                  ],
                ),
              ),
              _buildDurationInput(
                  'Timer', _selectedHours, _selectedMinutes, _selectedSeconds,
                  (hours, minutes, seconds) {
                setState(() {
                  _selectedHours = hours;
                  _selectedMinutes = minutes;
                  _selectedSeconds = seconds;
                  _updateDuration();
                });
              }),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    _button(
                      icon: Icons.play_arrow,
                      onPressed: () => _controller.restart(duration: _duration),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    _button(
                      icon: Icons.pause,
                      onPressed: () => _controller.pause(),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    _button(
                      icon: Icons.double_arrow,
                      onPressed: () => _controller.resume(),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildDistanceTracker(),
              const SizedBox(height: 20),
              const Text(
                'Water Tracker',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: List.generate(
                  _waterIntake,
                  (index) =>
                      Icon(Icons.local_drink, size: 50, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrettyCapsuleButton(
                    label: 'Add 0.5L'.toUpperCase(),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                    icon: Icons.local_drink,
                    bgColor: Colors.blue,
                    onPressed: () {
                      setState(() {
                        _waterIntake++;
                      });
                    },
                    /*icon: const Icon(Icons.local_drink_outlined,
                        size: 24, color: Colors.white),*/
                  ),
                  const SizedBox(width: 10),
                  PrettyCapsuleButton(
                    label: 'Remove 0.5L'.toUpperCase(),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                    icon: Icons.delete,
                    bgColor: Colors.blue,
                    onPressed: () {
                      setState(() {
                        if (_waterIntake > 0) _waterIntake--;
                      });
                    },
                    /*icon:
                        const Icon(Icons.remove, size: 24, color: Colors.white),*/
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Total: ${(_waterIntake * 0.5).toStringAsFixed(1)} liters / Goal: ${_waterGoal.toStringAsFixed(1)} liters',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceTracker() {
    double progress = _distanceGoal > 0 ? _todayDistance / _distanceGoal : 0.0;

    return Column(
      children: [
        const Text(
          'Distance Tracker',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _getDistanceComparisonMessage(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
            minHeight: 20,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${_todayDistance.toStringAsFixed(2)} km / ${_distanceGoal.toStringAsFixed(2)} km',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrettyCapsuleButton(
              label: 'Set Distance Goal'.toUpperCase(),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
              icon: Icons.directions_run,
              bgColor: Colors.blue,
              onPressed: () => _showGoalSettingDialog(context),
            ),
            const SizedBox(height: 10), // Add some spacing between buttons
            PrettyCapsuleButton(
              label: 'Your weekly chart'.toUpperCase(),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
              icon: Icons.bar_chart,
              bgColor: Colors.blue,
              onPressed: () => _showWeeklyChart(context),
            ),
          ],
        ),
      ],
    );
  }

  void _showWeeklyChart(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your weekly chart',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _buildWeeklyChartContent(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeeklyChartContent() {
    // Calculate the maximum distance for the y-axis range
    double maxDistance = 0;
    for (int i = 0; i < weeklyDistancesGraph.length; i++) {
      if (weeklyDistancesGraph[i] > maxDistance) {
        maxDistance = weeklyDistancesGraph[i];
      }
    }
    double yAxisMax = maxDistance + 5;

    return SizedBox(
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Mon';
                  case 1:
                    return 'Tue';
                  case 2:
                    return 'Wed';
                  case 3:
                    return 'Thu';
                  case 4:
                    return 'Fri';
                  case 5:
                    return 'Sat';
                  case 6:
                    return 'Sun';
                  default:
                    return '';
                }
              },
              getTextStyles: (context, value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              margin: 16,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (double value) {
                return '${value.toInt()} km';
              },
              getTextStyles: (context, value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              interval: 5,
              margin: 16,
            ),
            topTitles: SideTitles(showTitles: false), // Hide top titles
            rightTitles: SideTitles(showTitles: false), // Hide right titles
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: weeklyDistancesGraph.asMap().entries.map((entry) {
            int index = entry.key;
            double distance = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  y: distance,
                  width: 16,
                ),
              ],
            );
          }).toList(),
          maxY: yAxisMax, // Set the maximum y-axis value
        ),
      ),
    );
  }

  void _showGoalSettingDialog(BuildContext context) {
    TextEditingController goalController = TextEditingController();
    goalController.text = _distanceGoal.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Distance Goal'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Distance Goal (km)'),
          ),
          actions: [
            PrettyCapsuleButton(
              label: 'Save',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
              icon: Icons.save,
              bgColor: Colors.blue,
              onPressed: () {
                double newGoal =
                    double.tryParse(goalController.text) ?? _distanceGoal;
                _updateDistanceGoal(newGoal);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getDistanceComparisonMessage() {
    double difference = _todayDistance - weeklyDistanceMean;
    String comparison = difference > 0
        ? 'more'
        : difference < 0
            ? 'less'
            : 'equal to';

    return 'Today you walked ${difference.abs().toStringAsFixed(2)} km $comparison than your weekly average.';
  }

  Widget _button({required IconData icon, VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        onPressed: onPressed,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDurationInput(String label, int hours, int minutes, int seconds,
      Function(int, int, int) onChanged) {
    return SizedBox(
      width: 300, // Increase width
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          ScrollDateTimePicker(
            itemExtent: 40, // Adjust item extent for wider scroll
            infiniteScroll: true,
            dateOption: DateTimePickerOption(
              dateFormat: DateFormat('HHmmss'),
              minDate: DateTime(2000, 1, 1, 0, 0, 0), // Start from 0 hours
              maxDate: DateTime(2000, 1, 1, 23, 59, 59),
              initialDate: DateTime(2000, 1, 1, hours, minutes, seconds),
            ),
            onChange: (datetime) {
              setState(() {
                _selectedHours = datetime.hour;
                _selectedMinutes = datetime.minute;
                _selectedSeconds = datetime.second;
              });
              onChanged(datetime.hour, datetime.minute, datetime.second);
            },
            centerWidget: DateTimePickerCenterWidget(
              builder: (context, constraints, child) => const DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 3),
                    bottom: BorderSide(width: 3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateDuration() {
    setState(() {
      _duration =
          _selectedHours * 3600 + _selectedMinutes * 60 + _selectedSeconds;
    });
  }

  void updateHeartRateText() {
    setState(() {
      if (pulses.isNotEmpty) {
        final randomIndex = random.nextInt(pulses.length);
        final randomHeartRate = pulses[randomIndex].value;
        heartRateText = randomHeartRate.toString();
      } else {
        heartRateText = 'No data';
      }
    });
  }

  Future<void> getHeartRate() async {
    List<HeartRate>? heartRates = await HeartRateNotifier().fetchData();
    if (heartRates != null && heartRates.isNotEmpty) {
      pulses = heartRates;
    } else {
      pulses = [];
      print("Unable to fetch Heart Rate datas...");
    }
  }

  String getRandomHeartRate() {
    final randomIndex = Random().nextInt(pulses.length);
    final randomHeartRate = pulses[randomIndex].value;
    return randomHeartRate.toString();
  }

  void _checkPersonalInfoDeletion() async {
    final prefs = await SharedPreferences.getInstance();
    bool deleted = prefs.getBool('delete_personal') ?? false;
    if (deleted) {
      //Update text in distance tracker
      setState(() {
        weeklyDistanceMean = 0;
        todayDistances.clear();
        _todayDistance = 0;
        _waterIntake = 0;
        _distanceGoal = 5.0; // Reset to default goal
        weeklyDistances.clear();
      });
      prefs.remove('delete_personal');
    }
  }

  //Get distance
  Future<void> getDistance() async {
    List<Distance>? distance = await DistanceNotifier().fetchData(today);
    if (distance != null && distance.isNotEmpty) {
      todayDistances.clear();
      //Distance is in cm, convert it to meters
      for (int i = 0; i < distance.length; i++) {
        todayDistances.add(distance[i].value / 100000);
      }
      _todayDistance = 0.0;
      for (int i = 0; i < todayDistances.length; i++) {
        _todayDistance += todayDistances[i];
      }
    } else {
      print("Unable to fetch Distance datas...");
    }
  }

  //Get the mean of the weekly distance
  Future<void> getWeeklyDistanceMean() async {
    //List of 7 days before today
    final List<String> days = [];
    //Use today variable to get the current date
    final DateTime todayDate = DateTime.parse(today);
    //Get the day of the week
    final int dayOfWeek = todayDate.weekday;
    //Get the date of the last 7 days
    for (int i = 0; i < 7; i++) {
      final DateTime day = todayDate.subtract(Duration(days: dayOfWeek + i));
      days.add(day.toString().substring(0, 10));
    }
    //Get the distance of the last 7 days
    double totalDistance = 0.0;
    weeklyDistances.clear();
    for (int i = 0; i < days.length; i++) {
      List<Distance>? distance = await DistanceNotifier().fetchData(days[i]);
      //If the distance is not null and not empty add it to the list
      //Otherwise print an error message
      double dailyDistance = 0.0;
      if (distance != null && distance.isNotEmpty) {
        for (int j = 0; j < distance.length; j++) {
          dailyDistance += distance[j].value;
          totalDistance += distance[j].value;
        }
      } else {
        print("Unable to fetch Distance datas...");
      }
      weeklyDistances.add(dailyDistance / 100000);
    }
    //Calculate the mean
    weeklyDistanceMean = totalDistance / days.length / 100000;
    weeklyDistancesGraph = weeklyDistances;
  }

  // Get user weight from shared preferences and update water goal
  Future<void> getUserWeight() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userWeight = prefs.getDouble('weight') ?? 0.0;
      _waterGoal = _userWeight * 0.03; // 30 ml per kg converted to liters
    });
  }
}
