import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/models.dart';

class Visor3DScreen extends StatefulWidget {
  final double containerW;
  final double containerH;
  final double containerL;
  final List<PackedItem> items;

  const Visor3DScreen({
    super.key,
    required this.containerW,
    required this.containerH,
    required this.containerL,
    required this.items,
  });

  @override
  State<Visor3DScreen> createState() => _Visor3DScreenState();
}

class _Visor3DScreenState extends State<Visor3DScreen> with TickerProviderStateMixin {
  // Vista inicial configurada por defecto en 'Lateral'
  String _view = 'Lateral';
  
  double _rotX = 0.5;
  double _rotY = 0.8;
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;
  Offset _previousPanOffset = Offset.zero;

  bool _showPallets = true;
  bool _showWireframe = true;
  bool _isXRay = false;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.items.length;
    _setInitialAngles('Lateral');
  }

  void _setInitialAngles(String viewName) {
    setState(() {
      _view = viewName;
      _panOffset = Offset.zero;
      _zoom = 1.0;
      switch (viewName) {
        case 'Isométrica':
          _rotX = 0.5;
          _rotY = 0.8;
          break;
        case 'Planta':
          _rotX = 0.05;
          _rotY = 0.0;
          break;
        case 'Lateral':
          _rotX = 0.05;
          _rotY = math.pi / 2;
          break;
        case 'Puerta':
          _rotX = 0.05;
          _rotY = 0.0;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: Stack(
        children: [
          // Visor 3D Interactivo con CustomPainter
          GestureDetector(
            onPanStart: (_) => _previousPanOffset = _panOffset,
            onPanUpdate: (details) {
              setState(() {
                if (details.delta.distance > 0 && HardwareKeyboard.instance.isShiftPressed) {
                  // Paneo si se mantiene presionado Shift o es paneo libre
                  _panOffset = _previousPanOffset + details.delta;
                } else {
                  // Rotación orbital por defecto
                  _rotY -= details.delta.dx * 0.01;
                  _rotX = (_rotX - details.delta.dy * 0.01).clamp(-math.pi / 2, math.pi / 2);
                }
              });
            },
            onScaleUpdate: (details) {
              setState(() {
                _zoom = (_zoom * details.scale).clamp(0.4, 4.0);
              });
            },
            child: CustomPaint(
              painter: Visor3DPainter(
                containerW: widget.containerW,
                containerH: widget.containerH,
                containerL: widget.containerL,
                items: widget.items.take(_currentStep).toList(),
                rotX: _rotX,
                rotY: _rotY,
                zoom: _zoom,
                panOffset: _panOffset,
                showPallets: _showPallets,
                showWireframe: _showWireframe,
                isXRay: _isXRay,
              ),
              size: Size.infinite,
            ),
          ),

          // Barra Superior: Título y Botones de Vistas Predefinidas
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFF1E293B)),
                ),
                const SizedBox(width: 12),
                const Text('Visor 3D Enterprise', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: ['Isométrica', 'Planta', 'Lateral', 'Puerta'].map((v) {
                      final active = _view == v;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => _setInitialAngles(v),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: active ? const Color(0xFF0EA5E9) : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(v, style: TextStyle(color: active ? Colors.white : Colors.white60, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Botones de Control Lateral (Zoom y Rayos X)
          Positioned(
            top: 80,
            right: 16,
            child: Column(
              children: [
                _ControlButton(icon: Icons.add, label: 'Zoom +', onTap: () => setState(() => _zoom = (_zoom * 1.15).clamp(0.4, 4.0))),
                const SizedBox(height: 6),
                _ControlButton(icon: Icons.remove, label: 'Zoom -', onTap: () => setState(() => _zoom = (_zoom / 1.15).clamp(0.4, 4.0))),
                const SizedBox(height: 6),
                _ControlButton(
                  icon: Icons.blur_on,
                  label: 'Rayos X',
                  color: _isXRay ? const Color(0xFF0EA5E9) : null,
                  onTap: () => setState(() => _isXRay = !_isXRay),
                ),
                const SizedBox(height: 6),
                _ControlButton(icon: Icons.refresh, label: 'Reset', onTap: () => _setInitialAngles('Lateral')),
              ],
            ),
          ),

          // Barra Inferior de Control de Pasos (Timeline de Carga)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF111827).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: () => setState(() => _currentStep = 0),
                  ),
                  IconButton(
                    icon: Icon(_currentStep > 0 ? Icons.pause : Icons.play_arrow, color: const Color(0xFF38BDF8)),
                    onPressed: () {
                      setState(() {
                        if (_currentStep >= widget.items.length) {
                          _currentStep = 1;
                        } else {
                          _currentStep = widget.items.length;
                        }
                      });
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: _currentStep.toDouble(),
                      min: 0,
                      max: widget.items.length.toDouble().clamp(1, double.infinity),
                      divisions: widget.items.isEmpty ? 1 : widget.items.length,
                      activeColor: const Color(0xFF0EA5E9),
                      inactiveColor: Colors.white24,
                      onChanged: (val) => setState(() => _currentStep = val.toInt()),
                    ),
                  ),
                  Text('$_currentStep / ${widget.items.length}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _showPallets,
                        activeColor: const Color(0xFF0EA5E9),
                        onChanged: (v) => setState(() => _showPallets = v ?? true),
                      ),
                      const Text('Tarimas', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(width: 8),
                      Checkbox(
                        value: _showWireframe,
                        activeColor: const Color(0xFF0EA5E9),
                        onChanged: (v) => setState(() => _showWireframe = v ?? true),
                      ),
                      const Text('Marco', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ControlButton({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// Pintor 3D optimizado para renderizar el contenedor y las cajas
class Visor3DPainter extends CustomPainter {
  final double containerW, containerH, containerL;
  final List<PackedItem> items;
  final double rotX, rotY, zoom;
  final Offset panOffset;
  final bool showPallets, showWireframe, isXRay;

  Visor3DPainter({
    required this.containerW,
    required this.containerH,
    required this.containerL,
    required this.items,
    required this.rotX,
    required this.rotY,
    required this.zoom,
    required this.panOffset,
    required this.showPallets,
    required this.showWireframe,
    required this.isXRay,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2 + panOffset.dx, size.height / 2 + panOffset.dy);
    const scaleFactor = 1.2;
    final baseScale = math.min(size.width, size.height) / math.max(containerW, math.max(containerH, containerL)) * scaleFactor * zoom;

    // Centrar el contenedor en el origen 3D
    final cx = containerW / 2;
    final cy = containerH / 2;
    final cz = containerL / 2;

    Offset project(double x, double y, double z) {
      final nx = x - cx;
      final ny = y - cy;
      final nz = z - cz;

      // Rotación en Y
      final x1 = nx * math.cos(rotY) + nz * math.sin(rotY);
      final z1 = -nx * math.sin(rotY) + nz * math.cos(rotY);

      // Rotación en X
      final y2 = ny * math.cos(rotX) - z1 * math.sin(rotX);
      final z2 = ny * math.sin(rotX) + z1 * math.cos(rotX);

      // Proyección isométrica / perspectiva simple
      const distance = 1000.0;
      final perspective = distance / (distance + z2 + 300);

      return Offset(
        center.dx + x1 * baseScale * perspective,
        center.dy - y2 * baseScale * perspective, // Invertido en Y para coordenadas de pantalla
      );
    }

    // Dibujar Marco del Contenedor
    if (showWireframe) {
      final paintWire = Paint()
        ..color = Colors.white24
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      final corners = [
        [0.0, 0.0, 0.0], [containerW, 0.0, 0.0],
        [containerW, 0.0, containerL], [0.0, 0.0, containerL],
        [0.0, containerH, 0.0], [containerW, containerH, 0.0],
        [containerW, containerH, containerL], [0.0, containerH, containerL],
      ];

      final pts = corners.map((c) => project(c[0], c[1], c[2])).toList();

      const edges = [
        [0, 1], [1, 2], [2, 3], [3, 0],
        [4, 5], [5, 6], [6, 7], [7, 4],
        [0, 4], [1, 5], [2, 6], [3, 7],
      ];

      for (final e in edges) {
        canvas.drawLine(pts[e[0]], pts[e[1]], paintWire);
      }
    }

    // Dibujar Cajas / SKUs
    for (final item in items) {
      final itemColor = Color(item.colorHex).withValues(alpha: isXRay ? 0.35 : 0.9);
      final paintBox = Paint()
        ..color = itemColor
        ..style = PaintingStyle.fill;

      final paintBorder = Paint()
        ..color = Colors.black45
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;

      // Coordenadas de las caras de la caja
      final x0 = item.posX;
      final x1 = item.posX + item.width;
      final y0 = item.posY;
      final y1 = item.posY + item.height;
      final z0 = item.posZ;
      final z1 = item.posZ + item.length;

      // Caras simplificadas para renderizado rápido
      final p = [
        project(x0, y0, z0), project(x1, y0, z0),
        project(x1, y1, z0), project(x0, y1, z0),
        project(x0, y0, z1), project(x1, y0, z1),
        project(x1, y1, z1), project(x0, y1, z1),
      ];

      void drawFace(List<int> indices) {
        final path = Path().moveTo(p[indices[0]].dx, p[indices[0]].dy);
        for (int i = 1; i < indices.length; i++) {
          path.lineTo(p[indices[i]].dx, p[indices[i]].dy);
        }
        path.close();
        canvas.drawPath(path, paintBox);
        canvas.drawPath(path, paintBorder);
      }

      // Dibujar caras principales
      drawFace([0, 1, 2, 3]); // Frente
      drawFace([4, 5, 6, 7]); // Atrás
      drawFace([0, 4, 7, 3]); // Izquierda
      drawFace([1, 5, 6, 2]); // Derecha
      drawFace([3, 2, 6, 7]); // Arriba
      drawFace([0, 1, 5, 4]); // Abajo
    }
  }

  @override
  bool shouldRepaint(covariant Visor3DPainter oldDelegate) => true;
}