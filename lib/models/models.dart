import 'package:flutter/material.dart';

class TransportUnit {
  final String name;
  final double length, width, height, maxWeight;
  TransportUnit(this.name, this.length, this.width, this.height, this.maxWeight);
}

class SKU {
  String name;
  double length, width, height, weight;
  int quantity;
  Color color;
  SKU({
    required this.name,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.quantity,
    required this.color,
  });
}

class PackedItem {
  final String id, name;
  final double posX, posY, posZ, width, height, length;
  final int colorHex;
  final bool isPallet;
  final double weight;
  PackedItem({
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
    this.weight = 0,
  });
}