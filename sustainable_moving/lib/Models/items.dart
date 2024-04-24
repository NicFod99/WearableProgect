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
      name: 'Percorso Acquapendente',
      length: 3115,
      description:
          'Dalla sbarra del Bassanello fino al ponte di Via D’Acquapendente.',
      imagePath: 'assets/Pd1.jpg',
    ),
    PathData(
      name: 'Percorso Città Giardino',
      length: 2300,
      description:
          'Dalla sbarra del Bassanello attraversate l incrocio tenendovi sulla destra del ponte. Appena fatta la curva verso destra scendete dal marciapiede e correte accanto al fiume sulla stradina di erba/terra battuta. Passate sotto il ponte passerella e percorrete la strada fino ad arrivare al ponte Saracinesca. Attraversate il ponte e svoltate subito a destra per percorrere l argine alto alberato di Città Giardino fino ad arrivare al ponte passerella di ferro. Percorretela e svoltare a sinistra. scendete dal marciapiede e ripercorrerete il percorso fatto all andata.',
      imagePath: 'assets/Pd2.jpg',
    ),
    PathData(
      name: 'Percorso Facciolati',
      length: 5000,
      description:
          'Dalla sbarra del Bassanello fino al ponte di Via Facciolati. Fermatevi prima del secondo ponte all’incrocio con la strada e ritornate. Al ponte con via Acquapendente passate sotto il ponte con stradina in discesa che trovate a destra prima del ponte.',
      imagePath: 'assets/Pd3.jpg',
    ),
    PathData(
      name: 'Percorso Terranegra',
      length: 8220,
      description:
          'Dalla sbarra del Bassanello fino al ponte di Terranegra; fermatevi alla sbarra di ferro prima del ponte di Terranegra e ritornate. Al ponte con via Acquapendente e al ponte di Via Facciolati prendete la stradina in discesa che trovate a destra prima di entrambi i ponti. Dopo il passaggio sottoponte di via Facciolati attraversare la strada per rimettervi sul percorso.',
      imagePath: 'assets/Pd4.jpg',
    ),
    PathData(
      name: 'Percorso Camin',
      length: 10880,
      description:
          'Dalla sbarra del Bassanello fino al ponte di Terranegra; fermatevi alla sbarra di ferro prima del ponte di Terranegra e ritornate. Al ponte con via Acquapendente e al ponte di Via Facciolati prendete la stradina in discesa che trovate a destra prima di entrambi i ponti. Dopo il passaggio sottoponte di via Facciolati attraversare la strada per rimettervi sul percorso. Al ponte di Terranegra attraversate la strada e proseguire dritti. ',
      imagePath: 'assets/Pd5.jpg',
    ),
  ];
}
