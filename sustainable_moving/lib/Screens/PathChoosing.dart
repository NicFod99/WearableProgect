import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/distance.dart';
import 'package:sustainable_moving/Screens/profilePage.dart';
import 'dart:math';

class PathChoosingFeature extends StatefulWidget {
  const PathChoosingFeature({
    this.distance, // Making distance optional
    Key? key,
  }) : super(key: key);

  final Distance? distance; // Define distance as a member variable

  static const routename = 'PathChoosingFeature';

  @override
  _PathChoosingFeatureState createState() => _PathChoosingFeatureState();
}

class _PathChoosingFeatureState extends State<PathChoosingFeature> {
  @override
  Widget build(BuildContext context) {
    return HotelBookingScreen(
        distance: widget.distance); // Pass distance to HotelBookingScreen
  }
}

class HotelBookingScreen extends StatefulWidget {
  final Distance? distance; // Receive distance from PathChoosingFeature
  const HotelBookingScreen({Key? key, this.distance}) : super(key: key);

  @override
  _HotelBookingScreenState createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  late TextEditingController _placeController;
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  int _numberOfPeople = 1;
  int _numberOfRooms = 1;
  int _durationHours = 0;
  int _durationMinutes = 0;
  List<String> choices = [];
  int totalDistance = 0;

  @override
  void initState() {
    super.initState();
    _placeController = TextEditingController();
    _checkInDate = DateTime.now();
    _checkOutDate = _checkInDate.add(Duration(days: 1));
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _checkInDate) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  void _selectCheckOutDate(BuildContext context) async {
    DateTime initialDate =
        _checkOutDate.isBefore(_checkInDate.add(Duration(days: 1)))
            ? _checkInDate.add(Duration(days: 1))
            : _checkOutDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _checkInDate.add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  void _addChoiceToList() {
    // Generate a random distance value between 1 and 100 kilometers
    int randomDistance = Random().nextInt(20) + 1;

    String choice =
        'Place: ${_placeController.text} \nCheck-in: ${_checkInDate.toString().split(' ')[0]} \nCheck-out: ${_checkOutDate.toString().split(' ')[0]} \nDuration: $_durationHours hours $_durationMinutes minutes \nPeople: $_numberOfPeople \nRooms: $_numberOfRooms \nDistance: $randomDistance km\n_____________________________';

    setState(() {
      choices.add(choice);
      totalDistance += randomDistance;

      // Print "Ok" or "Not possible" based on the comparison
      if (widget.distance != null && widget.distance!.value > totalDistance) {
        print("Ok");
      } else {
        print("Not possible");
      }
    });
  }

  void _removeChoice(int index) {
    final removedChoice = choices[index];
    final regex = RegExp(r'Distance: (\d+) km');
    final match = regex.firstMatch(removedChoice);
    if (match != null) {
      final distance = int.parse(match.group(1)!);
      setState(() {
        choices.removeAt(index);
        totalDistance -= distance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Path choosing'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 30),
            Center(
              child: Row(
                children: [
                  SizedBox(width: 235),
                  Column(
                    children: [
                      Icon(
                        Icons.settings,
                      ),
                      Text("Settings"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _placeController,
              decoration: InputDecoration(
                labelText: 'Enter a place',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectCheckInDate(context),
                    child: Text(
                        'Check-in: ${_checkInDate.toString().split(' ')[0]}'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectCheckOutDate(context),
                    child: Text(
                        'Check-out: ${_checkOutDate.toString().split(' ')[0]}'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Duration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int minutes = int.tryParse(value) ?? 0;
                      setState(() {
                        if (minutes > 59) {
                          _durationHours += minutes ~/ 60;
                          _durationMinutes = minutes % 60;
                        } else {
                          _durationMinutes = minutes;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Minutes',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _durationHours = int.tryParse(value) ?? 0;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Hours',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'People',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _numberOfPeople = (_numberOfPeople > 1)
                                  ? _numberOfPeople - 1
                                  : 1;
                            });
                          },
                          icon: Icon(Icons.remove),
                        ),
                        Text('$_numberOfPeople'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _numberOfPeople++;
                            });
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rooms',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _numberOfRooms =
                                  (_numberOfRooms > 1) ? _numberOfRooms - 1 : 1;
                            });
                          },
                          icon: Icon(Icons.remove),
                        ),
                        Text('$_numberOfRooms'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _numberOfRooms++;
                            });
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                    onPressed: _addChoiceToList, child: Text("Add stop")),
                SizedBox(width: 50),
                Text(
                  'Total Distance: $totalDistance km',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Path in order:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: choices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(choices[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _removeChoice(index);
                      },
                    ),
                  );
                },
              ),
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
