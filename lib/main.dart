import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const TaiaoDexApp());

class TaiaoDexApp extends StatelessWidget {
  const TaiaoDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaiaoDex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
