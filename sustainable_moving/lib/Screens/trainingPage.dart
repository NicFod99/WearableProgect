import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sustainable_moving/Models/heartRate.dart';
import 'package:sustainable_moving/Models/heartRateNotifier.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:water_bottle/water_bottle.dart';

/* Training page pesante, ha diverse funzionalità.
 * 
 * TODO: Migliorare la grafica della pagina.
 *       Evitare che crashi l'app.
 *       Collegare il grafico con gli HeartRate e ridimensionarlo.
 *       Collegare nel timer anche le Ore. */

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  static const routename = 'trainingPage';

  @override
  _TrainingPage createState() => _TrainingPage();
}

class _TrainingPage extends State<TrainingPage> {
  List pulses = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Training Page"),
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
                              pulses.isNotEmpty ? getRandomHeartRate() : 'No data',
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
              _buildDurationInput('Timer', _selectedHours, _selectedMinutes, _selectedSeconds,
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
              Column(
                children: [
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
                      (index) => Icon(Icons.local_drink, size: 50, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _waterIntake++;
                          });
                        },
                        icon: const Icon(Icons.local_drink_outlined, size: 24, color: Colors.blue),
                        label: const Text('Add 0.5L'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (_waterIntake > 0) _waterIntake--;
                          });
                        },
                        icon: const Icon(Icons.remove, size: 24, color: Colors.blue),
                        label: const Text('Remove 0.5L'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total: ${(_waterIntake * 0.5).toStringAsFixed(1)} liters',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildDurationInput(
      String label, int hours, int minutes, int seconds, Function(int, int, int) onChanged) {
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
      _duration = _selectedHours * 3600 + _selectedMinutes * 60 + _selectedSeconds;
    });
  }

  @override
  void initState() {
    super.initState();

    getHeartRate();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      updateHeartRateText();
    });
  }

  void updateHeartRateText() {
    setState(() {
      if (pulses.isNotEmpty) {
        final randomIndex = random.nextInt(pulses.length);   
        final randomHeartRate =pulses[randomIndex].value;
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
      print("Unable to fetch Heart Rate datas...");
    }
  }

  String getRandomHeartRate() {
    final randomIndex = Random().nextInt(pulses.length);
    final randomHeartRate = pulses[randomIndex].value;
    return randomHeartRate.toString();
  }
}
