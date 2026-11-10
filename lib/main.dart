import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const OptiCargaApp());

class OptiCargaApp extends StatelessWidget {
  const OptiCargaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiCarga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}