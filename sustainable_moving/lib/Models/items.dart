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
  List<PathData> items;

  Catalog({required this.items});

  // PADOVA PATH
  static Catalog padovaCatalog() {
    return Catalog(items: [
      PathData(
        name: 'Acquapendente',
        length: 4900,
        description:
            'From the Bassanello barrier to the Via D’Acquapendente bridge.',
        imagePath: 'assets/Pd1.jpg',
        mapUrl:
            "https://www.google.com/maps/dir/Bassanello,+Padova,+PD/Ponte+di+San+Lorenzo,+Via+S.+Francesco,+28,+35123+Padova+PD/Bassanello,+Padova,+PD/@45.396751,11.862346,15z/data=!3m1!4b1!4m20!4m19!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m5!1m1!1s0x477eda50f76a1867:0x386b5feaf039e053!2m2!1d11.8776769!2d45.4062566!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!3e2?entry=ttu",
      ),
      PathData(
        name: 'Città Giardino',
        length: 3100,
        description:
            'From the Bassanello barrier cross the intersection keeping to the right of the bridge. As soon as you make the curve to the right, get off the sidewalk and run next to the river on the small grass/beaten earth road. Pass under the footbridge and walk along the road until you reach the Saracinesca Bridge. Cross the bridge and turn immediately right to walk along the high tree-lined embankment of Città Giardino until you reach the iron footbridge. Walk along it and turn left. Get off the sidewalk and retrace the route taken on the way out.',
        imagePath: 'assets/Pd2.jpg',
        mapUrl:
            "https://www.google.com/maps/dir/Bassanello,+35124+Padova+PD/Ponte+Saracinesca,+Padova,+PD/45.3921468,11.8674654/45.3872041,11.86768/@45.3863834,11.8664765,18.25z/data=!4m16!4m15!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m5!1m1!1s0x477edbb4a566c531:0x339ec5a45a72d391!2m2!1d11.8652267!2d45.3992272!1m0!1m0!3e2?entry=ttu",
      ),
      PathData(
        name: 'Facciolati',
        length: 5300,
        description:
            'From the Bassanello barrier to the Via Facciolati bridge. Stop before the second bridge at the intersection with the road and return. At the bridge with Acquapendente Street go under the bridge with small downhill road you find on the right before the bridge.',
        imagePath: 'assets/Pd3.jpg',
        mapUrl:
            "https://www.google.com/maps/dir/Bassanello,+Padova,+PD/45.3836086,11.8993081/Bassanello,+Padova,+PD/@45.3853517,11.8729331,15z/data=!3m1!4b1!4m15!4m14!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m0!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!3e2?entry=ttu",
      ),
      PathData(
        name: 'Terranegra',
        length: 8400,
        description:
            'From the Bassanello barrier to the Terranegra bridge; Stop at the iron bar before the Terranegra bridge and return. At the bridge with Via Acquapendente and at the Via Facciolati bridge, take the small downhill road on the right before both bridges. After the underbridge crossing of Via Facciolati cross the road to put yourself back on the path.',
        imagePath: 'assets/Pd4.jpg',
        mapUrl:
            "https://www.google.com/maps/dir/Bassanello,+35124+Padova+PD/Terranegra,+Padova,+PD/Bassanello,+Padova,+PD/@45.3893623,11.867546,14z/data=!3m1!4b1!4m20!4m19!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m5!1m1!1s0x477edb2062cc4db1:0xad21ef8fd3728dc2!2m2!1d11.9091989!2d45.3944279!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!3e2?entry=ttu",
      ),
      PathData(
        name: 'Camin',
        length: 10880,
        description:
            'From the Bassanello barrier to the Terranegra bridge; stop at the iron bar before the Terranegra bridge and return. At the bridge with Via Acquapendente and at the Via Facciolati bridge take the small downhill road on the right before both bridges. After the underbridge crossing of Via Facciolati cross the road to put yourself back on the path. At the Terranegra bridge cross the road and continue straight ahead.',
        imagePath: 'assets/Pd5.jpg',
        mapUrl:
            "https://www.google.com/maps/dir/Bassanello,+35124+Padova+PD/Terranegra,+Padova,+PD/Bassanello,+Padova,+PD/@45.3930588,11.8899415,15.1z/data=!4m20!4m19!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!1m5!1m1!1s0x477edb2062cc4db1:0xad21ef8fd3728dc2!2m2!1d11.9091989!2d45.3944279!1m5!1m1!1s0x477edba4dc863141:0x16c8f8fd6a38387f!2m2!1d11.8675778!2d45.3870423!3e2?entry=ttu",
      ),
    ]);
  }

  // VICENZA PATH
  static Catalog vicenzaCatalog() {
    return Catalog(items: [
      PathData(
        name: 'Strade delle 52 gallerie',
        length: 5700,
        description:
            'Corsa per esperti. Ottimo allenamento richiesto. Sono richiesti passo sicuro, calzature robuste ed esperienza alpinistica.',
        imagePath: 'assets/Vc1.jpg',
        mapUrl:
            "https://www.google.it/maps/dir/Parcheggio+2+della+strada+delle+52+Gallerie,+36030+Valli+del+Pasubio+VI/Rifugio+Generale+Achille+Papa,+Str.+degli+Eroi,+36030+Valli+del+Pasubio+VI/@45.7838499,11.1911706,13.98z/data=!4m14!4m13!1m5!1m1!1s0x4778af8680d6bb57:0xb1eff2113de4f881!2m2!1d11.2280026!2d45.7778502!1m5!1m1!1s0x4778a8dd312f2f3b:0xf8fa0ae9f6d29334!2m2!1d11.1858846!2d45.7838731!3e2?entry=ttu",
      ),
      PathData(
        name: 'Cima Portule e Cima Larici',
        length: 950,
        description:
            'L indice UV è molto alto su gran parte del tuo percorso. Ti consigliamo di utilizzare crema solare e occhiali da sole.',
        imagePath: 'assets/Vc2.jpg',
        mapUrl:
            "https://www.google.it/maps/dir/Cima+Portule,+36012+Asiago+VI/Cima+Larici,+36012+Asiago+VI/@45.979128,11.4229099,14.75z/am=t/data=!4m19!4m18!1m10!1m1!1s0x4778964b8a715fe5:0xc7c0d14bc4b3e8df!2m2!1d11.4467226!2d45.9793729!3m4!1m2!1d11.4311963!2d45.9765505!3s0x4778964dd7cd472f:0xdf5f72555b6061b5!1m5!1m1!1s0x477897a1270bff73:0xdfe8b6d279b3f796!2m2!1d11.4231477!2d45.9801275!3e2?entry=ttu",
      ),
      PathData(
        name: 'Cima Cornetto',
        length: 400,
        description:
            'From the Bassanello barrier to the Via Facciolati bridge. Stop before the second bridge at the intersection with the road and return. At the bridge with Acquapendente Street go under the bridge with small downhill road you find on the right before the bridge.',
        imagePath: 'assets/Vc3.jpg',
        mapUrl:
            "https://www.google.it/maps/dir/Malga+Bovental,+38060+Vallarsa+TN/Cima+del+Cornetto,+P5WG%2BQF,+38060+Vallarsa+TN/@45.7442722,11.1677073,17.5z/data=!4m14!4m13!1m5!1m1!1s0x4778a96774350727:0x69d74388fca4df92!2m2!1d11.167416!2d45.7454992!1m5!1m1!1s0x4778a9d7ab78c675:0x5914ef3cf1e1820d!2m2!1d11.1761531!2d45.7469785!3e2?entry=ttu",
      ),
    ]);
  }

  // VENEZIA PATH
  static Catalog veneziaCatalog() {
    return Catalog(items: [
      PathData(
        name: 'Parco di San Giuliano',
        length: 750,
        description: 'From Ponte of San Giuliano to the Center of the Park.',
        imagePath: 'assets/Vz1.png',
        mapUrl:
            "https://www.google.com/maps/dir/Ponte+San+Giuliano,+Via+Orlanda,+Venezia,+VE/Parco+di+San+Giuliano,+Via+Orlanda,+30173+Venezia+VE/@45.4738565,12.268959,16z/data=!4m14!4m13!1m5!1m1!1s0x477eb3f96c54a1a7:0xffa00ad4164feb20!2m2!1d12.2670732!2d45.477694!1m5!1m1!1s0x477eb3e3a7e6564d:0xe8dbeb23eb939ec3!2m2!1d12.2760376!2d45.4743271!3e2?entry=ttu",
      ),
      PathData(
        name: 'Parco Alfredo Albanese',
        length: 500,
        description: 'From the Area "Orti" to the center of the park.',
        imagePath: 'assets/Vz2.jpg',
        mapUrl:
            "https://www.google.it/maps/dir/Area+%22Orti%22,+Via+Rielta,+Venezia,+VE/Parco+Alfredo+Albanese,+Via+Gori,+8,+30172+Mestre+VE/@45.5005494,12.2606291,17z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x477eb52f50ee18ad:0x2eddd07731cadb9f!2m2!1d12.2654068!2d45.5020599!1m5!1m1!1s0x477eb46565bf38d3:0xbc21681d6154741a!2m2!1d12.2609032!2d45.4993575!3e2?entry=ttu",
      ),
      PathData(
        name: 'Parco delle Rimembranze',
        length: 550,
        description: 'From Giardini della biennale to the center of the park.',
        imagePath: 'assets/Vz3.jpg',
        mapUrl:
            "https://www.google.it/maps/dir/Giardini+della+Biennale,+Calle+Giazzo,+30122+Venezia+VE/Parco+delle+Rimembranze,+Venezia,+VE/@45.4279856,12.3565819,17.75z/data=!4m14!4m13!1m5!1m1!1s0x477eae31476436ab:0x19880826dceca689!2m2!1d12.3580806!2d45.4287722!1m5!1m1!1s0x477eae344bb1314f:0x3e9a3e936e11ff70!2m2!1d12.3596789!2d45.426707!3e2?entry=ttu",
      ),
    ]);
  }
}
