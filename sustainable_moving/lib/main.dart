import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '---- Path choosing ----',
      home: HotelBookingScreen(),
    );
  }
}

class HotelBookingScreen extends StatefulWidget {
  @override
  _HotelBookingScreenState createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  late TextEditingController _placeController;
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  int _numberOfPeople = 1;
  int _numberOfRooms = 1;
  List<String> choices = [];

  @override
  void initState() {
    super.initState();
    _placeController = TextEditingController();
    _checkInDate = DateTime.now();
    _checkOutDate = DateTime.now().add(Duration(
        days: 1)); // Default check-out date is one day after check-in date
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now()
          .add(Duration(days: 365)), // Limit to one year from today
    );
    if (picked != null && picked != _checkInDate) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate,
      firstDate: _checkInDate
          .add(Duration(days: 1)), // Check-out date must be after check-in date
      lastDate: DateTime.now()
          .add(Duration(days: 365)), // Limit to one year from today
    );
    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  void _addChoiceToList() {
    String choice =
        'Place: ${_placeController.text} \nCheck-in: ${_checkInDate.toString().split(' ')[0]} \nCheck-out: ${_checkOutDate.toString().split(' ')[0]} \nPeople: $_numberOfPeople \nRooms: $_numberOfRooms \n_____________________________';
    setState(() {
      choices.add(choice);
    });
  }

  void _removeChoice(int index) {
    setState(() {
      choices.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Path choosing'),
        centerTitle: true,
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('People'),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _numberOfPeople = (_numberOfPeople > 1)
                                    ? _numberOfPeople - 1
                                    : _numberOfPeople;
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
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rooms'),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _numberOfRooms = (_numberOfRooms > 1)
                                    ? _numberOfRooms - 1
                                    : _numberOfRooms;
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
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addChoiceToList,
              child: Text('Add place to visit'),
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
    );
  }
}
