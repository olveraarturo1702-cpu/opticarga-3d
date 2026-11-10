class PalletModel {
  final String name;
  final double width;
  final double length;
  final String usage;

  PalletModel({
    required this.name,
    required this.width,
    required this.length,
    required this.usage,
  });

  static List<PalletModel> standardPallets = [
    PalletModel(name: 'EUR (Europeo)', width: 80, length: 120, usage: 'Europa'),
    PalletModel(name: 'ISO', width: 100, length: 120, usage: 'Internacional'),
    PalletModel(name: 'Americano (GMA)', width: 101.6, length: 121.9, usage: 'USA/México'),
    PalletModel(name: 'Asia', width: 110, length: 110, usage: 'Asia'),
    PalletModel(name: 'Medio Palet', width: 80, length: 60, usage: 'Retail'),
    PalletModel(name: 'Cuarto Palet', width: 40, length: 60, usage: 'Exhibición'),
    PalletModel(name: 'Personalizada', width: 0, length: 0, usage: 'Especial'),
  ];
}