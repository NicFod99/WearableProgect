/* Classe PathData usato per cliccare dalla home ed aggiungere alla pagina 
 * favorite, è un listato dei percorsi i Padova. */

class PathData {
  final String name;
  final double length;
  final String description;
  final String imagePath;
  final String mapUrl;

  PathData({
    required this.name,
    required this.length,
    required this.description,
    required this.imagePath,
    required this.mapUrl,
  });
}

class Catalog {
  List<PathData> items = [
    PathData(
      name: 'Acquapendente path',
      length: 4900,
      description:
          'From the Bassanello barrier to the Via D’Acquapendente bridge.',
      imagePath: 'assets/Pd1.jpg',
      mapUrl:
          "https://www.google.com/maps/dir/Bassanello,+Padova,+PD/Ponte+di+San+Lorenzo,+Via+S.+Francesco,+28,+35123+Padova+PD/Bassanello,+Padova,+PD/@45.396751,11.862346,15z/data=!3m1!4b1!4m20!4m19!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m5!1m1!1s0x477eda50f76a1867:0x386b5feaf039e053!2m2!1d11.8776769!2d45.4062566!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!3e2?entry=ttu",
    ),
    PathData(
      name: 'Città Giardino path',
      length: 3100,
      description:
          'From the Bassanello barrier cross the intersection keeping to the right of the bridge. As soon as you make the curve to the right, get off the sidewalk and run next to the river on the small grass/beaten earth road. Pass under the footbridge and walk along the road until you reach the Saracinesca Bridge. Cross the bridge and turn immediately right to walk along the high tree-lined embankment of Città Giardino until you reach the iron footbridge. Walk along it and turn left. Get off the sidewalk and retrace the route taken on the way out.',
      imagePath: 'assets/Pd2.jpg',
      mapUrl: "https://www.google.com/maps/dir/Bassanello,+35124+Padova+PD/Ponte+Saracinesca,+Padova,+PD/45.3921468,11.8674654/45.3872041,11.86768/@45.3863834,11.8664765,18.25z/data=!4m16!4m15!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m5!1m1!1s0x477edbb4a566c531:0x339ec5a45a72d391!2m2!1d11.8652267!2d45.3992272!1m0!1m0!3e2?entry=ttu",
    ),
    PathData(
      name: 'Facciolati path',
      length: 5300,
      description:
          'From the Bassanello barrier to the Via Facciolati bridge. Stop before the second bridge at the intersection with the road and return. At the bridge with Acquapendente Street go under the bridge with small downhill road you find on the right before the bridge.',
      imagePath: 'assets/Pd3.jpg',
      mapUrl:
          "https://www.google.com/maps/dir/Bassanello,+Padova,+PD/45.3836086,11.8993081/Bassanello,+Padova,+PD/@45.3853517,11.8729331,15z/data=!3m1!4b1!4m15!4m14!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m0!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!3e2?entry=ttu",
    ),
    PathData(
      name: 'Terranegra path',
      length: 8400,
      description:
          'From the Bassanello barrier to the Terranegra bridge; Stop at the iron bar before the Terranegra bridge and return. At the bridge with Via Acquapendente and at the Via Facciolati bridge, take the small downhill road on the right before both bridges. After the underbridge crossing of Via Facciolati cross the road to put yourself back on the path.',
      imagePath: 'assets/Pd4.jpg',
      mapUrl: "https://www.google.com/maps/dir/Bassanello,+35124+Padova+PD/Terranegra,+Padova,+PD/Bassanello,+Padova,+PD/@45.3893623,11.867546,14z/data=!3m1!4b1!4m20!4m19!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m5!1m1!1s0x477edb2062cc4db1:0xad21ef8fd3728dc2!2m2!1d11.9091989!2d45.3944279!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!3e2?entry=ttu",
    ),
    PathData(
      name: 'Camin path',
      length: 10880,
      description:
          'From the Bassanello barrier to the Terranegra bridge; stop at the iron bar before the Terranegra bridge and return. At the bridge with Via Acquapendente and at the Via Facciolati bridge take the small downhill road on the right before both bridges. After the underbridge crossing of Via Facciolati cross the road to put yourself back on the path. At the Terranegra bridge cross the road and continue straight ahead.',
      imagePath: 'assets/Pd5.jpg',
      mapUrl: "https://www.google.com/maps/dir/Bassanello,+35124+Padova+PD/Terranegra,+Padova,+PD/Bassanello,+Padova,+PD/@45.3930588,11.8899415,15.1z/data=!4m20!4m19!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m5!1m1!1s0x477edb2062cc4db1:0xad21ef8fd3728dc2!2m2!1d11.9091989!2d45.3944279!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!3e2?entry=ttu",
    ),
  ];
}
