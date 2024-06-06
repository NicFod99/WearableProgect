/* Classe PathData usato per cliccare dalla home ed aggiungere alla pagina 
 * favorite, è un listato dei percorsi i Padova. */

class PathData {
  final String name;
  final double length;
  final String description;
  final String imagePath;

  PathData({
    required this.name,
    required this.length,
    required this.description,
    required this.imagePath,
  });
}

class Catalog {
  List<PathData> items = [
    PathData(
      name: 'Acquapendente path',
      length: 3115,
      description:
          'From the Bassanello barrier to the Via D’Acquapendente bridge.',
      imagePath: 'assets/Pd1.jpg',
    ),
    PathData(
      name: 'Città Giardino path',
      length: 2300,
      description:
          'From the Bassanello barrier cross the intersection keeping to the right of the bridge. As soon as you make the curve to the right, get off the sidewalk and run next to the river on the small grass/beaten earth road. Pass under the footbridge and walk along the road until you reach the Saracensca Bridge. Cross the bridge and turn immediately right to walk along the high tree-lined embankment of Garden City until you reach the iron footbridge. Walk along it and turn left. Get off the sidewalk and retrace the route taken on the way out.',
      imagePath: 'assets/Pd2.jpg',
    ),
    PathData(
      name: 'Facciolati path',
      length: 5000,
      description:
          'From the Bassanello barrier to the Via Facciolati bridge. Stop before the second bridge at the intersection with the road and return. At the bridge with Acquapendente Street go under the bridge with small downhill road you find on the right before the bridge.',
      imagePath: 'assets/Pd3.jpg',
    ),
    PathData(
      name: 'Terranegra path',
      length: 8220,
      description:
          'From the Bassanello barrier to the Terranegra bridge; Stop at the iron bar before the Terranegra bridge and return. At the bridge with Via Acquapendente and at the Via Facciolati bridge, take the small downhill road on the right before both bridges. After the underbridge crossing of Via Facciolati cross the road to put yourself back on the path.',
      imagePath: 'assets/Pd4.jpg',
    ),
    PathData(
      name: 'Camin path',
      length: 10880,
      description:
          'From the Bassanello barrier to the Terranegra bridge; stop at the iron bar before the Terranegra bridge and return. At the bridge with Via Acquapendente and at the Via Facciolati bridge take the small downhill road on the right before both bridges. After the underbridge crossing of Via Facciolati cross the road to put yourself back on the path. At the Terranegra bridge cross the road and continue straight ahead.',
      imagePath: 'assets/Pd5.jpg',
    ),
  ];
}
