import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_moving/Models/favorite.dart';
import 'package:sustainable_moving/Screens/FavoritePage.dart';
import 'package:provider/provider.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({Key? key}) : super(key: key);

  static const routename = 'ChoosePage';

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class PathData {
  final String name;
  final double length;
  final String description;

  PathData({
    required this.name,
    required this.length,
    required this.description,
  });
}

class _ChoosePageState extends State<ChoosePage> {
  int index = 0;

  static const List<String> imagePaths = [
    'assets/Pd1.jpg',
    'assets/Pd2.jpg',
    'assets/Pd3.jpg',
    'assets/Pd4.jpg',
    'assets/Pd5.jpg',
    // Add more image paths as needed
  ];

  static List<PathData> imageText = [
    PathData(
      name: 'Percorso Acquapendente',
      length: 3115,
      description:
          'Dalla sbarra del Bassanello fino al ponte di Via D’Acquapendente.',
    ),
    PathData(
      name: 'Percorso Città Giardino',
      length: 2300,
      description:
          'Dalla sbarra del Bassanello attraversate l incrocio tenendovi sulla destra del ponte. Appena fatta la curva verso destra scendete dal marciapiede e correte accanto al fiume sulla stradina di erba/terra battuta. Passate sotto il ponte passerella e percorrete la strada fino ad arrivare al ponte Saracinesca. Attraversate il ponte e svoltate subito a destra per percorrere l argine alto alberato di Città Giardino fino ad arrivare al ponte passerella di ferro. Percorretela e svoltare a sinistra. scendete dal marciapiede e ripercorrerete il percorso fatto all andata.',
    ),
    PathData(
      name: 'Percorso Facciolati',
      length: 5000,
      description:
          'Dalla sbarra del Bassanello fino al ponte di Via Facciolati. Fermatevi prima del secondo ponte all’incrocio con la strada e ritornate. Al ponte con via Acquapendente passate sotto il ponte con stradina in discesa che trovate a destra prima del ponte.',
    ),
    PathData(
      name: 'Percorso Terranegra',
      length: 8220,
      description:
          'Dalla sbarra del Bassanello fino al ponte di Terranegra; fermatevi alla sbarra di ferro prima del ponte di Terranegra e ritornate. Al ponte con via Acquapendente e al ponte di Via Facciolati prendete la stradina in discesa che trovate a destra prima di entrambi i ponti. Dopo il passaggio sottoponte di via Facciolati attraversare la strada per rimettervi sul percorso.',
    ),
    PathData(
      name: 'Percorso Camin',
      length: 10880,
      description:
          'Dalla sbarra del Bassanello fino al ponte di Terranegra; fermatevi alla sbarra di ferro prima del ponte di Terranegra e ritornate. Al ponte con via Acquapendente e al ponte di Via Facciolati prendete la stradina in discesa che trovate a destra prima di entrambi i ponti. Dopo il passaggio sottoponte di via Facciolati attraversare la strada per rimettervi sul percorso. Al ponte di Terranegra attraversate la strada e proseguire dritti. ',
    ),
  ];

  late Timer _timer;
  List<bool> selected = List.filled(imagePaths.length, false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('${ChoosePage.routename} built');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome back Runner!"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Destination Nearby",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/
                    200, // Adjust 200 according to your preference
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio:
                    4 / 3, // Adjust aspect ratio to maintain consistency
              ),
              itemCount: imagePaths.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected[index] = true; // Set the selected state to true
                    });
                    Provider.of<Favorite>(context, listen: false)
                        .addProduct(imagePaths[index]);

                    // Set up a timer to revert the selection after 0.5 seconds
                    Timer(Duration(milliseconds: 500), () {
                      setState(() {
                        selected[index] =
                            false; // Set the selected state back to false
                      });
                    });
                  },
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 4 /
                            3, // Set the aspect ratio to maintain consistency
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (selected[index])
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            imageText[index].name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              shadows: [
                                Shadow(
                                  color: Colors.white
                                      .withOpacity(1), // Shadow color
                                  offset: Offset(3, 3), // Shadow offset
                                  blurRadius: 10, // Shadow blur radius
                                ),
                              ],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toFavoritePage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FavoritePage()));
  }
}
