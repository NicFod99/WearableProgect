import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State with SingleTickerProviderStateMixin {
  late TextEditingController _personalInfoController;
  String _personalInfo = "Your personal info"; // Initial personal info text
  late String _newPersonalInfo; // Variable to store the new personal info text
  late String _imagePath; // Variable to store the selected image path

  @override
  void initState() {
    super.initState();
    _personalInfoController = TextEditingController(text: _personalInfo);
    _imagePath = ""; // Initialize imagePath to an empty string
  }

  @override
  void dispose() {
    _personalInfoController.dispose();
    super.dispose();
  }

  void _modifyPersonalInfo() {
    // Update the personal info with the new text
    setState(() {
      _personalInfo = _newPersonalInfo;
    });
    Navigator.pop(context); // Close the dialog
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            ),
            SizedBox(height: 5),
            _imagePath.isNotEmpty
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.20),
                          child: Image.file(
                            File(_imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(), // Empty SizedBox if no image selected
            SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.camera_enhance,
                  size: 24, // Adjust the size of the icon as needed
                ),
                label: Text("Edit Picture"), // Empty Text widget as the label
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Personal Info",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _personalInfo,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Modify Personal Info'),
                        content: TextField(
                          controller: _personalInfoController,
                          onChanged: (value) {
                            _newPersonalInfo = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter new personal info",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: _modifyPersonalInfo,
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.edit),
                label: Text("Edit Personal Info"),
              ),
            ),
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
    );
  }
}
