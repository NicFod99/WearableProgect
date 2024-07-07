import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:sustainable_moving/Screens/navBar.dart';
import 'dart:io';
import '/utils/authorize_utils.dart';
import 'package:provider/provider.dart';
import 'package:sustainable_moving/Models/heartRateNotifier.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:nice_buttons/nice_buttons.dart';

/* Profile page, utilizzata dall'utente per cambiare foto e info.
 * 
 * TODO: Migliorare qusta pagina aggiungendo funzionalità per l'utente, fate voi.*/

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
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

    _loadProfileInfo();
    _saveProfileInfo();
  }

  Future<void> _loadProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? _name;
      _surname = prefs.getString('surname') ?? _surname;
      _height = prefs.getInt('height') ?? _height;
      _weight = prefs.getDouble('weight') ?? _weight;
      _sex = prefs.getString('sex') ?? _sex;
      _age = prefs.getInt('age') ?? _age;
      _imagePath = prefs.getString('imagePath') ?? _imagePath;

      _nameController.text = _name;
      _surnameController.text = _surname;
      _heightController.text = _height.toString();
      _weightController.text = _weight.toString();
      _sexController.text = _sex;
      _ageController.text = _age.toString();
    });
  }

  Future<void> _saveProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name);
    await prefs.setString('surname', _surname);
    await prefs.setInt('height', _height);
    await prefs.setDouble('weight', _weight);
    await prefs.setString('sex', _sex);
    await prefs.setInt('age', _age);
    await prefs.setString('imagePath', _imagePath);
  }

  Future<void> _deleteProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', '');
    await prefs.setString('surname', '');
    await prefs.setInt('height', 0);
    await prefs.setDouble('weight', 0);
    await prefs.setString('sex', 'M');
    await prefs.setInt('age', 0);
    await prefs.setString('imagePath', '');
    await prefs.setBool('delete_personal', true);
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
      _height = int.tryParse(_heightController.text) ?? 0;
      _weight = double.tryParse(_weightController.text) ?? 0;
      _sex = _sexController.text;
      _age = int.tryParse(_ageController.text) ?? 0;
    });
    _saveProfileInfo();
    Navigator.pop(context);
  }

  void _deletePersonalInfo() {
    // Clear the personal info and image path
    // In a real app you would need to call an API to delete the personal info from the server
    setState(() {
      _name = "";
      _surname = "";
      _height = 0;
      _weight = 0.0;
      _age = 0;
      _imagePath = "";
      _nameController.text = "";
      _surnameController.text = "";
      _heightController.text = "";
      _weightController.text = "";
      _ageController.text = "";
    });
    _deleteProfileInfo();
    //Remove data in the providers
    Provider.of<HeartRateNotifier>(context, listen: false).clearFavorite();
    Provider.of<Favorite>(context, listen: false).clearFavorite();
    Navigator.pop(context); // Close the dialog
    AuthorizeUtils.unauthorize();
  }

  // Funzione per prendere la foto dalla galleria (funziona bene, testato).
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      _saveProfileInfo();
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
              const Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
              ),
              const SizedBox(height: 10),
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
                          : const Icon(Icons.person,
                              size: 80), // Placeholder icon if no image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        child: const Icon(Icons.edit),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Name: $_name",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Surname: $_surname",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Height: $_height cm",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Weight: $_weight kg",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Sex: $_sex",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Age: $_age",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              NiceButtons(
                stretch: true,
                gradientOrientation: GradientOrientation.Horizontal,
                onTap: (finish) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Modify Profile Info'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                            ),
                            TextField(
                              controller: _surnameController,
                              decoration:
                                  const InputDecoration(labelText: 'Surname'),
                            ),
                            TextField(
                              controller: _heightController,
                              decoration:
                                  const InputDecoration(labelText: 'Height'),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              controller: _weightController,
                              decoration:
                                  const InputDecoration(labelText: 'Weight'),
                              keyboardType: TextInputType.number,
                            ),
                            DropdownButtonFormField<String>(
                              value: _sex,
                              onChanged: (newValue) {
                                setState(() {
                                  _sex = newValue!;
                                });
                              },
                              items: [
                                'M',
                                'F'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            TextField(
                              controller: _ageController,
                              decoration:
                                  const InputDecoration(labelText: 'Age'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: _modifyProfileInfo,
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Edit Profile Info',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              //PrettyNeumorphicButton(
              //label: 'Edit Personal Info',
              //icon: Icons.edit,
              //bgColor: Colors.blue, // Sostituisci con il colore desiderato
              //),
              const SizedBox(height: 10),
              // Button to delete personal info
              /*PrettyCapsuleButton(
                label: 'Delete Personal Info'.toUpperCase(),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                icon: Icons.delete,
                bgColor: Colors.blue, // Sostituisci con il colore desiderato
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Personal Info'),
                        content: const Text(
                            'Are you sure you want to delete your personal info?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: _deletePersonalInfo,
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),*/
              PrettyWaveButton(
                // ignore: sort_child_properties_last
                child: const Text(
                  'Delete Personal Info',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.blue,
                verticalPadding: 12,
                horizontalPadding: 34,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Personal Info'),
                        content: const Text(
                            'Are you sure you want to delete your personal info?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: _deletePersonalInfo,
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              PrettySlideIconButton(
                foregroundColor: Colors.blue,
                icon: Icons.delete,
                label: 'Delete Personal Info',
                slidePosition: SlidePosition.left,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Personal Info'),
                        content: const Text(
                            'Are you sure you want to delete your personal info?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: _deletePersonalInfo,
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              PrettyCapsuleButton(
                label: 'Authorize the app'.toUpperCase(),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                icon: Icons.done,
                bgColor: Colors.blue, // Sostituisci con il colore desiderato
                onPressed: () async {
                  final result = await AuthorizeUtils.authorize();
                  if (result == 200) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(content: Text('Request successful')));
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(content: Text('Request failed')));
                  }
                },
              ),
              const SizedBox(height: 10),
              PrettyCapsuleButton(
                label: 'Unauthorize the app'.toUpperCase(),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                icon: Icons.not_interested,
                bgColor: Colors.blue, // Sostituisci con il colore desiderato
                onPressed: () async {
                  await AuthorizeUtils.unauthorize();
                  //Remove data in the providers
                  Provider.of<HeartRateNotifier>(context, listen: false)
                      .clearFavorite();
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                        content: Text('Tokens have been deleted')));
                },
              ),
              const SizedBox(height: 20),
              const Text(
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
              const SizedBox(height: 10),
              const Align(
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
