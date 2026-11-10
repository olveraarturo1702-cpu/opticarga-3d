import 'package:flutter/material.dart';
import '../models/models.dart';
import 'visor_3d_screen.dart';
import '../widgets/pallet_dropdown_widget.dart';

// Widget desplegable para agregar SKUs estándar de forma rápida
class SKUDropdownWidget extends StatefulWidget {
  final Function(SKU selectedSKU) onSelected;

  const SKUDropdownWidget({super.key, required this.onSelected});

  @override
  State<SKUDropdownWidget> createState() => _SKUDropdownWidgetState();
}

class _SKUDropdownWidgetState extends State<SKUDropdownWidget> {
  SKU? _selectedSKU;

  final List<SKU> _presets = [
    SKU(name: 'Caja Pequeña', length: 30, width: 20, height: 15, weight: 3, quantity: 20, color: const Color(0xFF22C55E)),
    SKU(name: 'Caja Mediana', length: 40, width: 30, height: 25, weight: 6, quantity: 15, color: const Color(0xFF3B82F6)),
    SKU(name: 'Caja Grande', length: 60, width: 40, height: 40, weight: 12, quantity: 10, color: const Color(0xFFEF4444)),
    SKU(name: 'Caja XL', length: 80, width: 60, height: 50, weight: 20, quantity: 6, color: const Color(0xFF8B5CF6)),
    SKU(name: 'IBC 1000L', length: 120, width: 100, height: 116, weight: 60, quantity: 2, color: const Color(0xFF06B6D4)),
    SKU(name: 'Caja Cartón #1', length: 25, width: 20, height: 15, weight: 2, quantity: 30, color: const Color(0xFFF59E0B)),
    SKU(name: 'Caja Cartón #2', length: 35, width: 25, height: 20, weight: 4, quantity: 25, color: const Color(0xFFEC4899)),
  ];

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
        child: DropdownButton<SKU>(
          value: _selectedSKU,
          hint: const Text('Seleccionar SKU / Caja estándar...', style: TextStyle(color: Colors.white54, fontSize: 13)),
          isExpanded: true,
          dropdownColor: const Color(0xFF111827),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF38BDF8)),
          items: _presets.map((sku) {
            return DropdownMenuItem<SKU>(
              value: sku,
              child: Text(
                '${sku.name} (${sku.length.toInt()}×${sku.width.toInt()}×${sku.height.toInt()} cm)',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedSKU = val);
              widget.onSelected(val);
              setState(() => _selectedSKU = null);
            }
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final units = [
    TransportUnit('Contenedor 20 ft Estándar', 590, 235, 239, 21800),
    TransportUnit('Contenedor 20 ft High Cube', 590, 235, 269, 21800),
    TransportUnit('Contenedor 40 ft Estándar', 1203, 235, 239, 27600),
    TransportUnit('Contenedor 40 ft High Cube (HC)', 1203, 235, 269, 29000),
    TransportUnit('Contenedor 45 ft High Cube', 1356, 235, 269, 29000),
    TransportUnit('Contenedor 20 ft Refrigerado', 545, 229, 226, 21000),
    TransportUnit('Contenedor 40 ft Refrigerado', 1156, 229, 250, 27700),
    TransportUnit('Contenedor Open Top 20 ft', 590, 235, 235, 21800),
    TransportUnit('Contenedor Open Top 40 ft', 1203, 235, 235, 26600),
    TransportUnit('Contenedor Flat Rack 20 ft', 594, 240, 232, 31000),
    TransportUnit('Contenedor Flat Rack 40 ft', 1206, 240, 195, 45000),
    TransportUnit('Caja Seca 48 ft', 1440, 250, 260, 21500),
    TransportUnit('Caja Seca 53 ft (Tráiler)', 1600, 250, 270, 20500),
    TransportUnit('Caja Seca 53 ft High Cube', 1600, 250, 290, 20000),
    TransportUnit('Plataforma 40 ft', 1219, 244, 60, 30000),
    TransportUnit('Plataforma 48 ft', 1463, 244, 60, 28000),
    TransportUnit('Plataforma 53 ft', 1615, 244, 60, 25000),
    TransportUnit('Camión Torton (Rabón)', 700, 240, 250, 14000),
    TransportUnit('Camión Full (Trailer)', 1400, 250, 270, 25000),
    TransportUnit('Camión 3.5 Ton', 420, 190, 190, 3500),
    TransportUnit('Camión 5 Ton', 500, 210, 210, 5000),
  ];

  // Variables de trabajo editables para las dimensiones de la unidad actual
  late String currentUnitName;
  late double currentLength;
  late double currentWidth;
  late double currentHeight;
  late double currentMaxWeight;

  final skus = <SKU>[];

  @override
  void initState() {
    super.initState();
    _loadUnit(units[3]); // High Cube 40 ft por defecto
  }

  void _loadUnit(TransportUnit u) {
    currentUnitName = u.name;
    currentLength = u.length;
    currentWidth = u.width;
    currentHeight = u.height;
    currentMaxWeight = u.maxWeight;
  }

  String _getImage(String name) {
    if (name.contains('Refrigerado')) return 'assets/images/reefer.png';
    if (name.contains('Open Top')) return 'assets/images/opentop.png';
    if (name.contains('Flat Rack')) return 'assets/images/flatrack.png';
    if (name.contains('Caja Seca')) return 'assets/images/caja_seca.png';
    if (name.contains('Plataforma')) return 'assets/images/plataforma.png';
    if (name.contains('Camión')) return 'assets/images/camion.png';
    return 'assets/images/container.png';
  }

  double get totalVolume {
    double v = 0;
    for (final s in skus) {
      v += (s.length * s.width * s.height * s.quantity) / 1000000;
    }
    return v;
  }

  double get totalWeight {
    double w = 0;
    for (final s in skus) {
      w += s.weight * s.quantity;
    }
    return w;
  }

  double get containerVolume => (currentLength * currentWidth * currentHeight) / 1000000;
  double get volumePercent => containerVolume > 0 ? (totalVolume / containerVolume) * 100 : 0;
  double get weightPercent => currentMaxWeight > 0 ? (totalWeight / currentMaxWeight) * 100 : 0;
  int get totalBoxes => skus.fold(0, (sum, s) => sum + s.quantity);

  void _showUnitPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF0B1220),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 30, offset: Offset(0, -4))],
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 48, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(3))),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(Icons.local_shipping_outlined, color: Color(0xFF38BDF8), size: 22),
                  SizedBox(width: 10),
                  Text('Seleccionar Unidad', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: units.length,
                itemBuilder: (_, i) {
                  final u = units[i];
                  final selected = u.name == currentUnitName;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _loadUnit(u);
                          });
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF1E3A5F) : const Color(0xFF111827),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selected ? const Color(0xFF38BDF8) : Colors.white.withValues(alpha: 0.05),
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  _getImage(u.name),
                                  width: 56,
                                  height: 36,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 56,
                                    height: 36,
                                    color: const Color(0xFF1E3A5F),
                                    child: const Icon(Icons.local_shipping, color: Color(0xFF38BDF8), size: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(u.name, style: TextStyle(color: selected ? const Color(0xFF38BDF8) : Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                                    const SizedBox(height: 2),
                                    Text('${u.length.toInt()} × ${u.width.toInt()} × ${u.height.toInt()} cm', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                                  ],
                                ),
                              ),
                              Text('${(u.maxWeight / 1000).toStringAsFixed(1)} t', style: TextStyle(color: selected ? const Color(0xFF38BDF8) : Colors.white60, fontWeight: FontWeight.w600, fontSize: 12)),
                              if (selected) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.check_circle, color: Color(0xFF38BDF8), size: 18),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSKU() {
    setState(() {
      skus.add(SKU(
        name: 'Nuevo SKU',
        length: 50,
        width: 40,
        height: 30,
        weight: 20,
        quantity: 10,
        color: Colors.primaries[skus.length % Colors.primaries.length],
      ));
    });
  }

  void _calculate() {
    final items = <PackedItem>[];
    double px = 0;
    double pz = 0;
    double py = 0;
    double maxRowLength = 0;
    double maxRowHeight = 0;
    int id = 0;

    for (final sku in skus) {
      for (int q = 0; q < sku.quantity; q++) {
        if (px + sku.width > currentWidth) {
          px = 0;
          pz += maxRowLength;
          maxRowLength = 0;
        }

        if (pz + sku.length > currentLength) {
          pz = 0;
          px = 0;
          py += maxRowHeight > 0 ? maxRowHeight : sku.height;
          maxRowHeight = 0;
        }

        items.add(PackedItem(
          id: 'item_$id',
          name: sku.name,
          posX: px,
          posY: py,
          posZ: pz,
          width: sku.width,
          height: sku.height,
          length: sku.length,
          colorHex: sku.color.toARGB32(),
          weight: sku.weight,
        ));

        px += sku.width;
        if (sku.length > maxRowLength) maxRowLength = sku.length;
        if (sku.height > maxRowHeight) maxRowHeight = sku.height;
        id++;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Visor3DScreen(
          containerW: currentWidth,
          containerH: currentHeight,
          containerL: currentLength,
          items: items,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            color: const Color(0xFF0F172A),
            child: const Row(
              children: [
                Icon(Icons.view_in_ar, color: Color(0xFF38BDF8), size: 22),
                SizedBox(width: 10),
                Text('OptiCarga 3D — Enterprise Logistics Suite', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('ESTADO DE UTILIZACIÓN DE FLOTA', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text(currentUnitName, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _ProgressBar(label: 'Capacidad Cúbica', value: volumePercent, color: const Color(0xFF38BDF8))),
                            const SizedBox(width: 24),
                            Expanded(child: _ProgressBar(label: 'Límite de Peso', value: weightPercent, color: const Color(0xFF22C55E))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.local_shipping, color: Color(0xFF38BDF8), size: 18),
                            SizedBox(width: 8),
                            Text('1. Selección de Unidad de Transporte', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _showUnitPicker,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0B1220),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    _getImage(currentUnitName),
                                    width: 100,
                                    height: 62,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 100,
                                      height: 62,
                                      decoration: BoxDecoration(color: const Color(0xFF1E3A5F), borderRadius: BorderRadius.circular(8)),
                                      child: const Icon(Icons.local_shipping, color: Color(0xFF38BDF8), size: 28),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Tipo de Unidad Logística', style: TextStyle(color: Colors.white54, fontSize: 11)),
                                      const SizedBox(height: 3),
                                      Text(currentUnitName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                      const SizedBox(height: 2),
                                      Text('${currentLength.toInt()} × ${currentWidth.toInt()} × ${currentHeight.toInt()} cm  •  ${(currentMaxWeight / 1000).toStringAsFixed(1)} t máx', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.unfold_more, color: Colors.white38, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Dimensiones Personalizadas del Contenedor (cm)', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _UnitDimensionField(
                                label: 'Largo',
                                value: currentLength.toStringAsFixed(0),
                                onChanged: (v) {
                                  setState(() {
                                    currentLength = double.tryParse(v) ?? currentLength;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _UnitDimensionField(
                                label: 'Ancho',
                                value: currentWidth.toStringAsFixed(0),
                                onChanged: (v) {
                                  setState(() {
                                    currentWidth = double.tryParse(v) ?? currentWidth;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _UnitDimensionField(
                                label: 'Alto',
                                value: currentHeight.toStringAsFixed(0),
                                onChanged: (v) {
                                  setState(() {
                                    currentHeight = double.tryParse(v) ?? currentHeight;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Tipo de Tarima Estándar (Opcional)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        PalletDropdownWidget(
                          onSelected: (pallet) {
                            setState(() {
                              skus.add(SKU(
                                name: pallet.name,
                                length: pallet.length,
                                width: pallet.width,
                                height: pallet.height,
                                weight: pallet.weight,
                                quantity: 1,
                                color: const Color(0xFFB45309),
                              ));
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.inventory_2, color: Color(0xFF38BDF8), size: 18),
                            const SizedBox(width: 8),
                            const Text('2. Especificación de Carga (SKUs)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: _addSKU,
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Agregar SKU', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SKUDropdownWidget(
                          onSelected: (selectedSKU) {
                            setState(() {
                              skus.add(SKU(
                                name: selectedSKU.name,
                                length: selectedSKU.length,
                                width: selectedSKU.width,
                                height: selectedSKU.height,
                                weight: selectedSKU.weight,
                                quantity: selectedSKU.quantity,
                                color: selectedSKU.color,
                              ));
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        ...skus.asMap().entries.map((e) => _SKURow(
                          sku: e.value,
                          onDelete: () => setState(() => skus.removeAt(e.key)),
                          onChanged: () => setState(() {}),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text('Calcular Acomodo 3D Enterprise', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Card(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _Stat(icon: Icons.inventory, label: 'Cajas Cargadas', value: '$totalBoxes u', color: const Color(0xFF38BDF8)),
                            _Stat(icon: Icons.view_in_ar, label: 'Volumen Utilizado', value: '${totalVolume.toStringAsFixed(2)} m³ (${volumePercent.toStringAsFixed(1)}%)', color: const Color(0xFF22C55E)),
                            _Stat(icon: Icons.scale, label: 'Peso Total', value: '${totalWeight.toStringAsFixed(0)} kg (${weightPercent.toStringAsFixed(1)}%)', color: const Color(0xFFF59E0B)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: child,
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _ProgressBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: (value / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white12, color: color),
        ),
        const SizedBox(height: 4),
        Text('${value.toStringAsFixed(1)}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _UnitDimensionField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  const _UnitDimensionField({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          const SizedBox(height: 2),
          TextField(
            controller: TextEditingController(text: value)
              ..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SKURow extends StatelessWidget {
  final SKU sku;
  final VoidCallback onDelete;
  final VoidCallback onChanged;
  const _SKURow({required this.sku, required this.onDelete, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: sku.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: sku.color.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.inventory_2, color: sku.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: _SKUField(label: 'Nombre', value: sku.name, onChanged: (v) { sku.name = v; onChanged(); })),
          const SizedBox(width: 8),
          Expanded(child: _SKUField(label: 'Largo', value: sku.length.toStringAsFixed(0), suffix: 'cm', onChanged: (v) { sku.length = double.tryParse(v) ?? sku.length; onChanged(); })),
          const SizedBox(width: 8),
          Expanded(child: _SKUField(label: 'Ancho', value: sku.width.toStringAsFixed(0), suffix: 'cm', onChanged: (v) { sku.width = double.tryParse(v) ?? sku.width; onChanged(); })),
          const SizedBox(width: 8),
          Expanded(child: _SKUField(label: 'Alto', value: sku.height.toStringAsFixed(0), suffix: 'cm', onChanged: (v) { sku.height = double.tryParse(v) ?? sku.height; onChanged(); })),
          const SizedBox(width: 8),
          Expanded(child: _SKUField(label: 'Peso', value: sku.weight.toStringAsFixed(0), suffix: 'kg', onChanged: (v) { sku.weight = double.tryParse(v) ?? sku.weight; onChanged(); })),
          const SizedBox(width: 8),
          Expanded(child: _SKUField(label: 'Cant.', value: sku.quantity.toString(), onChanged: (v) { sku.quantity = int.tryParse(v) ?? sku.quantity; onChanged(); })),
          const SizedBox(width: 4),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 18), splashRadius: 18),
        ],
      ),
    );
  }
}

class _SKUField extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final ValueChanged<String> onChanged;
  const _SKUField({required this.label, required this.value, this.suffix, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: value)
                    ..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                  onChanged: onChanged,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: 4),
                Text(suffix!, style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _Stat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }
}