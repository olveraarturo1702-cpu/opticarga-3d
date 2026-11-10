class BoxSpec {
  final String id;
  final String name;
  final double width;   // X
  final double height;  // Y
  final double length;  // Z
  final double weight;
  final int colorHex;
  final int qty;

  BoxSpec({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    required this.length,
    required this.weight,
    required this.colorHex,
    this.qty = 1,
  });
}

class PalletSpec {
  final double width;   // X del palet
  final double length;  // Z del palet
  final double height;  // altura del palet (usualmente 15 cm)

  PalletSpec({
    this.width = 120,
    this.length = 100,
    this.height = 15,
  });
}

class PackedResult {
  final String id;
  final String name;
  final double posX, posY, posZ;
  final double width, height, length;
  final int colorHex;
  final bool isPallet;

  PackedResult({
    required this.id,
    required this.name,
    required this.posX,
    required this.posY,
    required this.posZ,
    required this.width,
    required this.height,
    required this.length,
    required this.colorHex,
    this.isPallet = false,
  });
}

class PalletPacker {
  /// Empaqueta cajas sobre palets dentro del contenedor.
  /// Ejes: X=ancho, Y=alto, Z=largo
  static List<PackedResult> pack({
    required double containerW,
    required double containerH,
    required double containerL,
    required PalletSpec pallet,
    required List<BoxSpec> boxes,
  }) {
    final result = <PackedResult>[];
    final units = <_Unit>[];

    for (final b in boxes) {
      for (int i = 0; i < b.qty; i++) {
        units.add(_Unit(
          id: '${b.id}_$i',
          name: b.name,
          w: b.width,
          h: b.height,
          l: b.length,
          color: b.colorHex,
        ));
      }
    }

    // Ordenar por volumen descendente
    units.sort((a, b) => (b.w * b.h * b.l).compareTo(a.w * a.h * a.l));

    double palletX = 0;
    double palletZ = 0;

    while (units.isNotEmpty) {
      // ¿Cabe otro palet en X?
      if (palletX + pallet.width > containerW) {
        palletX = 0;
        palletZ += pallet.length;
      }
      // ¿Cabe en Z?
      if (palletZ + pallet.length > containerL) break;

      // Colocar palet
      result.add(PackedResult(
        id: 'pallet_${palletX}_$palletZ',
        name: 'Palet',
        posX: palletX,
        posY: 0,
        posZ: palletZ,
        width: pallet.width,
        height: pallet.height,
        length: pallet.length,
        colorHex: 0xFFB45309,
        isPallet: true,
      ));

      // Cajas sobre este palet
      double boxX = palletX;
      double boxZ = palletZ;
      double rowDepth = 0;
      final baseY = pallet.height;

      final remaining = <_Unit>[];
      for (final u in units) {
        // ¿Cabe en la fila del palet?
        if (boxX + u.w > palletX + pallet.width) {
          boxZ += rowDepth;
          boxX = palletX;
          rowDepth = 0;
        }
        // ¿Cabe en el palet (Z) y en altura?
        if (boxZ + u.l > palletZ + pallet.length || baseY + u.h > containerH) {
          remaining.add(u);
          continue;
        }

        result.add(PackedResult(
          id: u.id,
          name: u.name,
          posX: boxX,
          posY: baseY,
          posZ: boxZ,
          width: u.w,
          height: u.h,
          length: u.l,
          colorHex: u.color,
        ));

        boxX += u.w;
        if (u.l > rowDepth) rowDepth = u.l;
      }

      units
        ..clear()
        ..addAll(remaining);

      palletX += pallet.width;
    }

    return result;
  }
}

class _Unit {
  final String id, name;
  final double w, h, l;
  final int color;
  _Unit({required this.id, required this.name, required this.w, required this.h, required this.l, required this.color});
}