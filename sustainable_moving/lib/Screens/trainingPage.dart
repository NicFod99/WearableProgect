import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text("Training Page"), // Adjust the spacing as needed
          ],
        ),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView to handle overflow
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isCalendarVisible = !_isCalendarVisible;
                  });
                },
                child: Text(
                  "${DateTime.now().toString().substring(0, 10)}",
                  style: TextStyle(fontSize: 25),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 150),
                  Transform.scale(
                    scale: 10.0, // Adjust the scale factor as needed
                    child: Icon(Icons.favorite),
                  ),
                  SizedBox(width: 120),
                  Icon(Icons.person),
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
                          Text(
                            _total.toString(),
                            style: TextStyle(
                              fontSize: 24, // Adjust the font size as needed
                            ),
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
              onPressed: () {
                Navigator.of(context).pop();
                // Add the new number to the existing total
                setState(() {
                  _total -= number;
                });
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
              onPressed: () {
                Navigator.of(context).pop();
                // Add the new number to the existing total
                setState(() {
                  _total += number;
                });
              },
              child: Text('OK'),
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

  // Variable to hold the total distance
}
