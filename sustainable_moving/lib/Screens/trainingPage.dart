import 'dart:async';
import 'dart:math';
import 'package:draw_graph/draw_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  HeartRateNotifier lista = HeartRateNotifier();
  final Random random = Random();
  String heartRateText = 'No data';
  final CountDownController _controller = CountDownController();
  int _duration = 0;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;
  DateTime time = DateTime.now();
  /* Variabili per l'animazione, consiglio di cercare il main dell'example su git
   * della relativa funzione (ho fatto quasi copia e incolla), se serve. */
  final plainBottleRef = GlobalKey<WaterBottleState>();
  final sphereBottleRef = GlobalKey<SphericalBottleState>();
  final triangleBottleRef = GlobalKey<TriangularBottleState>();
  var waterLevel = 0.5;
  var selectedStyle = 0;

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
                // ROW DEL CUORE E DEL TIMER
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
                        /* E' il cuore che prende un valore random dal listato
                         * pulses del notifier di heartRate e lo mostra a schermo
                         * ci sono stacked la scritta e l'icona del cuore. */
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
                    /* Timer settato da _Duration a 0, collegato al widget che 
                     * crea lo slider del tempo, con cui è incolonnato. */
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
                      isReverse: true,
                      isReverseAnimation: false,
                      isTimerTextShown: true,
                      autoStart: false,
                    ),
                  ],
                ),
              ),
              _buildDurationInput('Timer', _selectedMinutes,
                  (minutes, seconds) {
                setState(() {
                  _selectedMinutes = minutes;
                  _selectedSeconds = seconds;
                  _updateDuration();
                });
              }),
              // BOTTONI IN ROW DEL TIMER.
              SizedBox(height: 20),
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
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Column(
                    /* Colonnato tra widget dell'acqua e il grafico i HeartRate 
                     * e dell'acqua bevuta. Sono entrambi presi di PubDev.com */
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWaterSlide(), // <- DECOMMENTA QUA PER LO SLIDER ACQUA.
                      FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Tasks Track",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            LineGraph(
                              features: features,
                              size: Size(300, 300),
                              labelX: [
                                'Day 1',
                                'Day 2',
                                'Day 3',
                                'Day 4',
                                'Day 5',
                              ],
                              labelY: ['20%', '40%', '60%', '80%', '100%'],
                              showDescription: true,
                              graphColor: Colors.black,
                              graphOpacity: 0.2,
                              verticalFeatureDirection: false,
                              descriptionHeight: 100,
                            ),
                          ],
                        ),
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

  // Layout del bottone.
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

  // Funzioni copia e incolla dell'acqua slider,
  Widget _buildPickerLabel(String label) {
    return Text(label);
  }

  Widget _buildWaterSlide() {
    final plain = WaterBottle(
      key: plainBottleRef,
      waterColor: Colors.blue,
      bottleColor: Colors.lightBlue,
      capColor: Colors.blueGrey,
    );
    final sphere = SphericalBottle(
      key: sphereBottleRef,
      waterColor: Colors.red,
      bottleColor: Colors.redAccent,
      capColor: Colors.grey.shade700,
    );
    final triangle = TriangularBottle(
      key: triangleBottleRef,
      waterColor: Colors.lime,
      bottleColor: Colors.limeAccent,
      capColor: Colors.red,
    );
    final bottle = Center(
      child: SizedBox(
        width: 200,
        height: 300,
        child: selectedStyle == 0
            ? plain
            : selectedStyle == 1
                ? sphere
                : triangle,
      ),
    );
    final stylePicker = Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Center(
        child: ToggleButtons(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: Icon(Icons.crop_portrait),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: Icon(Icons.circle_outlined),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: Icon(Icons.change_history),
            ),
          ],
          isSelected: List<bool>.generate(3, (index) => index == selectedStyle),
          onPressed: (index) {
            setState(() => selectedStyle = index);
            plainBottleRef.currentState?.waterLevel = waterLevel;
            sphereBottleRef.currentState?.waterLevel = waterLevel;
            triangleBottleRef.currentState?.waterLevel = waterLevel;
          },
        ),
      ),
    );
    final waterSlider = Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.opacity),
          SizedBox(width: 10),
          Expanded(
            child: Slider(
              value: waterLevel,
              //max: 1.0,
              min: 0.0,
              onChanged: (value) {
                setState(() {
                  waterLevel = value;
                  plainBottleRef.currentState?.waterLevel = waterLevel;
                  sphereBottleRef.currentState?.waterLevel = waterLevel;
                  triangleBottleRef.currentState?.waterLevel = waterLevel;
                });
              },
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        bottle,
        stylePicker,
        waterSlider,
      ],
    );
  }

  // Settaggio del timer slider. Anche qua più o meno copia e incolla.
  Widget _buildDurationInput(
      String label, int value, Function(int, int) onChanged) {
    return SizedBox(
      width: 300, // Increase width
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          ScrollDateTimePicker(
            itemExtent: 40, // Adjust item extent for wider scroll
            infiniteScroll: true,
            dateOption: DateTimePickerOption(
              dateFormat: DateFormat(
                'HHmmss',
              ),
              minDate: DateTime(2000, 6),
              maxDate: DateTime(2024, 6),
              initialDate: DateTime.now(),
            ),
            onChange: (datetime) {
              setState(() {
                _selectedMinutes = datetime.minute;
                _selectedSeconds = datetime.second;
              });
              onChanged(datetime.minute, datetime.second);
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
      _duration = _selectedMinutes * 60 + _selectedSeconds;
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<HeartRateNotifier>(context, listen: false).getHeartRate();
    Provider.of<HeartRateNotifier>(context, listen: false).authorize();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      updateHeartRateText();
    });
    _updateDuration();
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

  List<double> _dataPicker() {
    List<double> heartRatetoList =
        lista.pulses.map((e) => e.value.toDouble()).toList();
    return heartRatetoList.take(5).toList();
  }
}
