import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';


import '../data/sample_species.dart';
import '../models/species.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

  // You can tweak/extend this later.
  static const List<String> _statusOptions = [
    'Not Threatened',
    'At Risk',
    'Endangered',
    'Critically Endangered',
  ];

  // If empty => show all statuses.
  final Set<String> _selectedStatuses = {};

  List<Species> get _filteredSpecies {
    final q = _query.trim().toLowerCase();

    bool matchesQuery(Species s) {
      if (q.isEmpty) return true;

      final english = removeDiacritics(s.name).toLowerCase();
      final maori = removeDiacritics(s.maoriName).toLowerCase();
      final query = removeDiacritics(q).toLowerCase();

      return english.contains(query) || maori.contains(query);
    }

    bool matchesStatus(Species s) {
      if (_selectedStatuses.isEmpty) return true;
      return _selectedStatuses.contains(s.conservationStatus);
    }

    final filtered = sampleSpecies
        .where((s) => matchesQuery(s) && matchesStatus(s))
        .toList();

    // Optional: nice sorting (A–Z)
    filtered.sort((a, b) => a.name.compareTo(b.name));
    return filtered;
  }

  void _clearSearch() {
    setState(() => _query = '');
  }

  void _toggleStatus(String status) {
    setState(() {
      if (_selectedStatuses.contains(status)) {
        _selectedStatuses.remove(status);
      } else {
        _selectedStatuses.add(status);
      }
    });
  }

  void _clearFilters() {
    setState(() => _selectedStatuses.clear());
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSpecies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaiaoDex 🌿'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                // Search bar
                TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Search (English or Māori)…',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.clear),
                          ),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Filter chips row (horizontal scroll)
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final status in _statusOptions)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(status),
                                  selected:
                                      _selectedStatuses.contains(status),
                                  onSelected: (_) => _toggleStatus(status),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedStatuses.isNotEmpty)
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Clear'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: filtered.isEmpty
            ? _EmptyState(
                query: _query,
                hasStatusFilter: _selectedStatuses.isNotEmpty,
                onClearAll: () {
                  setState(() {
                    _query = '';
                    _selectedStatuses.clear();
                  });
                },
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: SpeciesGrid(species: filtered),
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  final bool hasStatusFilter;
  final VoidCallback onClearAll;

  const _EmptyState({
    required this.query,
    required this.hasStatusFilter,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final showClear = query.trim().isNotEmpty || hasStatusFilter;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 44),
            const SizedBox(height: 10),
            const Text(
              'No birds found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              showClear
                  ? 'Try adjusting your search or filters.'
                  : 'Add some birds to your dataset to see them here.',
              textAlign: TextAlign.center,
            ),
            if (showClear) ...[
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: onClearAll,
                child: const Text('Clear search & filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SpeciesGrid extends StatelessWidget {
  final List<Species> species;
  const SpeciesGrid({super.key, required this.species});

  int _columnsForWidth(double w) {
    if (w >= 1000) return 5;
    if (w >= 780) return 4;
    if (w >= 560) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = _columnsForWidth(width);

    return GridView.builder(
      itemCount: species.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) => SpeciesCard(species: species[index]),
    );
  }
}

class SpeciesCard extends StatelessWidget {
  final Species species;
  const SpeciesCard({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Next step later: navigate to detail screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped: ${species.name}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  species.image,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    height: 90,
                    color: Colors.black12,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                species.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
