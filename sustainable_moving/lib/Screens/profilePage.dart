import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:sustainable_moving/Impact/impact.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/* Profile page, utilizzata dall'utente per cambiare foto e info.
 * 
 * TODO: Migliorare qusta pagina aggiungendo funzionalità per l'utente, fate voi.*/

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _sexController;
  late TextEditingController _ageController;

  String _name = "Antonio";
  String _surname = "Ramirez";
  int _height = 182;
  double _weight = 72;
  String _sex = "M";
  int _age = 36;
  late String _imagePath; // Variable to store the selected image path

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _name);
    _surnameController = TextEditingController(text: _surname);
    _heightController = TextEditingController(text: _height.toString());
    _weightController = TextEditingController(text: _weight.toString());
    _sexController = TextEditingController(text: _sex);
    _ageController = TextEditingController(text: _age.toString());
    _imagePath = "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _sexController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _modifyProfileInfo() {
    setState(() {
      _name = _nameController.text;
      _surname = _surnameController.text;
      _height = int.parse(_heightController.text);
      _weight = double.parse(_weightController.text);
      _sex = _sexController.text;
      _age = int.tryParse(_ageController.text) ?? 0;
    });
    Navigator.pop(context);
  }

  void _deletePersonalInfo() {
    // Clear the personal info and image path
    // In a real app you would need to call an API to delete the personal info from the server
    setState(() {
      _name = "";
      _surname = "";
      _height = 0;
      _weight = 0;
      _age = 0;
      _imagePath = "";
      _nameController.text = "";
      _surnameController.text = "";
      _heightController.text = "";
      _weightController.text = "";
      _ageController.text = "";

    });
    Navigator.pop(context); // Close the dialog
  }

  // Funzione per prendere la foto dalla galleria (funziona bene, testato).
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            ),
            SizedBox(height: 5),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: _imagePath.isNotEmpty
                        ? ClipOval(
                            child: Image.file(
                              File(_imagePath),
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          )
                        : Icon(Icons.person, size: 80), // Placeholder icon if no image
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: Icon(Icons.edit),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Name: $_name",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Surname: $_surname",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Height: $_height cm",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Weight: $_weight kg",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Sex: $_sex",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Age: $_age",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Modify Profile Info'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                          TextField(
                            controller: _surnameController,
                            decoration: InputDecoration(labelText: 'Surname'),
                          ),
                          TextField(
                            controller: _heightController,
                            decoration: InputDecoration(labelText: 'Height'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: _weightController,
                            decoration: InputDecoration(labelText: 'Weight'),
                            keyboardType: TextInputType.number,
                          ),
                          DropdownButtonFormField<String>(
                            value: _sex,
                            onChanged: (newValue) {
                              setState(() {
                                _sex = newValue!;
                              });
                            },
                            items: ['M', 'F']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          TextField(
                            controller: _ageController,
                            decoration: InputDecoration(labelText: 'Age'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: _modifyProfileInfo,
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Edit Profile Info"),
            ),
            // Button to delete personal info
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Personal Info'),
                      content: Text(
                          'Are you sure you want to delete your personal info?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: _deletePersonalInfo,
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Delete Personal Info"),
            ),
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
            SizedBox(height: 20),
            Text(
              "About",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Sustainable moving aims to allow you to choose a better and sustainable path. Every use external from the Unipd environment is sanctioned by copyright. Work done by Quasi Engineers team.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text("Version alpha 1.0.0"),
            ),
          ],
        ),
      ),
    ),
  );
}
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
