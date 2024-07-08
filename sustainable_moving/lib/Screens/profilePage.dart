import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                          child: const Icon(
                            Icons.edit,
                            color: Color.fromARGB(255, 7, 126, 11),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Name: $_name",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Surname: $_surname",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Height: $_height cm",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Weight: $_weight kg",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Sex: $_sex",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Age: $_age",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 210,
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Edit Profile Info',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            content: SingleChildScrollView(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.6,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _nameController,
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                        labelText: 'Name',
                                        labelStyle: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors
                                                .black, // Colore della linea quando il TextField non è selezionato
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width:
                                                2, // Colore della linea quando il TextField è selezionato
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: _surnameController,
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                        labelText: 'Surname',
                                        labelStyle: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors
                                                .black, // Colore della linea quando il TextField non è selezionato
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width:
                                                2, // Colore della linea quando il TextField è selezionato
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: _heightController,
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                        labelText: 'Height (cm)',
                                        labelStyle: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors
                                                .black, // Colore della linea quando il TextField non è selezionato
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width:
                                                2, // Colore della linea quando il TextField è selezionato
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    TextField(
                                      controller: _weightController,
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                        labelText: 'Weight (kg)',
                                        labelStyle: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors
                                                .black, // Colore della linea quando il TextField non è selezionato
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width:
                                                2, // Colore della linea quando il TextField è selezionato
                                          ),
                                        ),
                                      ),
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
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                        labelText: 'Sex',
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: _ageController,
                                      cursorColor: Colors.black,
                                      decoration: const InputDecoration(
                                        labelText: 'Age',
                                        labelStyle: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors
                                                .black, // Colore della linea quando il TextField non è selezionato
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width:
                                                2, // Colore della linea quando il TextField è selezionato
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Color.fromARGB(255, 6, 114, 9),
                                  )),
                              TextButton(
                                  onPressed: _modifyProfileInfo,
                                  child: const Text(
                                    'Save',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Color.fromARGB(255, 6, 114, 9),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text('Edit Profile Info',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 9, 166, 14),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 210,
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Delete Personal Info',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            content: const Text(
                                'Are you sure you want to delete your personal info?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Color.fromARGB(255, 6, 114, 9),
                                    //backgroundColor: Color.fromARGB(255, 6, 114, 9),
                                  )),
                              TextButton(
                                  onPressed: _deletePersonalInfo,
                                  child: const Text(
                                    'Delete',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Color.fromARGB(255, 6, 114, 9),
                                    //backgroundColor: Color.fromARGB(255, 6, 114, 9),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text('Delete Personal Info',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 9, 166, 14),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                NiceButtons(
                  startColor: Color.fromARGB(255, 9, 166, 14),
                  endColor: Color.fromARGB(255, 9, 166, 14),
                  borderColor: Color.fromARGB(255, 7, 126, 11),
                  width: 210,
                  height: 40,
                  stretch: false,
                  gradientOrientation: GradientOrientation.Horizontal,
                  onTap: (finish) async {
                    final result = await AuthorizeUtils.authorize();
                    if (result == 200) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                            content: Text('Request successful')));
                    } else {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            const SnackBar(content: Text('Request failed')));
                    }
                  },
                  child: Text(
                    'Authorize the app',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 10),
                NiceButtons(
                  startColor: Color.fromARGB(255, 9, 166, 14),
                  endColor: Color.fromARGB(255, 9, 166, 14),
                  borderColor: Color.fromARGB(255, 7, 126, 11),
                  width: 210,
                  height: 40,
                  stretch: false,
                  gradientOrientation: GradientOrientation.Horizontal,
                  onTap: (finish) async {
                    await AuthorizeUtils.unauthorize();
                    //Remove data in the providers
                    Provider.of<HeartRateNotifier>(context, listen: false)
                        .clearFavorite();
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                          content: Text('Tokens have been deleted')));
                  },
                  child: Text(
                    'Unauthorize the app',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
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
                    textAlign: TextAlign.justify),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: Text("Version alpha 1.0.0"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
