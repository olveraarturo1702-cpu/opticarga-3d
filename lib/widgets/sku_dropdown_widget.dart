import 'package:flutter/material.dart';

class StandardSKUOption {
  final String name;
  final double length;
  final double width;
  final double height;
  final double weight;
  final Color color;

  StandardSKUOption({
    required this.name,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.color,
  });

  static List<StandardSKUOption> presets = [
    StandardSKUOption(name: 'Palet EUR (120x80)', length: 120, width: 80, height: 15, weight: 25, color: const Color(0xFFB45309)),
    StandardSKUOption(name: 'Palet ISO (120x100)', length: 120, width: 100, height: 15, weight: 28, color: const Color(0xFF92400E)),
    StandardSKUOption(name: 'Caja Pequeña', length: 30, width: 20, height: 15, weight: 3, color: const Color(0xFF22C55E)),
    StandardSKUOption(name: 'Caja Mediana', length: 40, width: 30, height: 25, weight: 6, color: const Color(0xFF3B82F6)),
    StandardSKUOption(name: 'Caja Grande', length: 60, width: 40, height: 40, weight: 12, color: const Color(0xFFEF4444)),
    StandardSKUOption(name: 'Caja XL', length: 80, width: 60, height: 50, weight: 20, color: const Color(0xFF8B5CF6)),
    StandardSKUOption(name: 'IBC 1000L', length: 120, width: 100, height: 116, weight: 60, color: const Color(0xFF06B6D4)),
  ];
}

class SKUDropdownWidget extends StatefulWidget {
  final Function(StandardSKUOption selectedOption) onSelected;

  const SKUDropdownWidget({super.key, required this.onSelected});

  @override
  State<SKUDropdownWidget> createState() => _SKUDropdownWidgetState();
}

class _SKUDropdownWidgetState extends State<SKUDropdownWidget> {
  StandardSKUOption? _selectedOption;

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
        child: DropdownButton<StandardSKUOption>(
          value: _selectedOption,
          hint: const Text(
            'Seleccionar caja/tarima estándar...',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          isExpanded: true,
          dropdownColor: const Color(0xFF111827),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF38BDF8)),
          items: StandardSKUOption.presets.map((preset) {
            return DropdownMenuItem<StandardSKUOption>(
              value: preset,
              child: Text(
                '${preset.name} (${preset.length.toInt()}×${preset.width.toInt()}×${preset.height.toInt()} cm)',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedOption = val);
              widget.onSelected(val);
              // Opcional: reinicia la selección para poder elegir la misma otra vez si se desea
              setState(() => _selectedOption = null);
            }
          },
        ),
      ),
    );
  }
}