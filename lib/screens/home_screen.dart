import 'package:flutter/material.dart';

import '../data/sample_species.dart';
import '../models/species.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaiaoDex 🌿'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SpeciesGrid(species: sampleSpecies),
        ),
      ),
    );
  }
}

class SpeciesGrid extends StatelessWidget {
  final List<Species> species;

  const SpeciesGrid({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    // Responsive columns: 2 on phones, more on larger screens
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 900
        ? 5
        : width >= 700
            ? 4
            : width >= 500
                ? 3
                : 2;

    return GridView.builder(
      itemCount: species.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        return SpeciesCard(species: species[index]);
      },
    );
  }
}

class SpeciesCard extends StatelessWidget {
  final Species species;

  const SpeciesCard({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped: ${species.name}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder for now (we’ll swap to real images next)
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black12,
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 32),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                species.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                species.scientificName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const Spacer(),
              Text(
                species.conservationStatus,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
