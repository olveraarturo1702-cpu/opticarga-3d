import 'package:flutter/material.dart';

class PalletType {
  final String name;
  final double length;
  final double width;
  final double height;
  final double weight;

  PalletType(this.name, this.length, this.width, this.height, this.weight);

  static List<PalletType> standards = [
    PalletType('EUR (Europeo)', 120, 80, 15, 25),
    PalletType('ISO', 120, 100, 15, 28),
    PalletType('Americano (GMA)', 121.9, 101.6, 15, 30),
    PalletType('Asia', 110, 110, 15, 26),
    PalletType('Medio Palet', 80, 60, 15, 15),
    PalletType('Cuarto Palet', 60, 40, 15, 10),
  ];
}

class PalletDropdownWidget extends StatefulWidget {
  final Function(PalletType selected) onSelected;

  const PalletDropdownWidget({super.key, required this.onSelected});

  @override
  State<PalletDropdownWidget> createState() => _PalletDropdownWidgetState();
}

class _PalletDropdownWidgetState extends State<PalletDropdownWidget> {
  PalletType? _current;

  @override
  void initState() {
    super.initState();
    _current = PalletType.standards.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PalletType>(
          value: _current,
          isExpanded: true,
          dropdownColor: const Color(0xFF111827),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF38BDF8)),
          items: PalletType.standards.map((p) {
            return DropdownMenuItem<PalletType>(
              value: p,
              child: Text(
                '${p.name} (${p.length.toInt()} × ${p.width.toInt()} cm)',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _current = val);
              widget.onSelected(val);
            }
          },
        ),
      ),
    );
  }
}