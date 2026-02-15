import 'package:flutter/material.dart';
import 'data/sample_species.dart';

void main() {
  runApp(const TaiaoDexApp());
}

class TaiaoDexApp extends StatelessWidget {
  const TaiaoDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaiaoDex',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final species = sampleSpecies[0];

    return Scaffold(
      appBar: AppBar(title: const Text("TaiaoDex 🌿")),
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(species.name,
                    style:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(species.scientificName,
                    style: const TextStyle(fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                Text("Habitat: ${species.habitat}"),
                Text("Status: ${species.conservationStatus}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
