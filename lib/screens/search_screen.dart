import 'package:flutter/material.dart';
import '../services/quran_service.dart';
import '../services/hadith_service.dart';
import 'quran/quran_reader.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final QuranService _quranService = QuranService();
  final HadithService _hadithService = HadithService();

  List<Map<String, dynamic>>? _quranResults;
  List<Map<String, dynamic>>? _hadithResults;
  bool _isLoading = false;
  String _error = '';

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = '';
      _quranResults = null;
      _hadithResults = null;
    });

    try {
      final quranResults = await _quranService.searchQuran(query);
      final hadithResults = await _hadithService.searchHadiths(query);

      if (mounted) {
        setState(() {
          _quranResults = quranResults;
          _hadithResults = hadithResults['results'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error performing search: $e';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
          child: Text(_error, style: const TextStyle(color: Colors.red)));
    }

    if (_quranResults == null && _hadithResults == null) {
      return const Center(child: Text('Search for verses and hadiths'));
    }

    if (_quranResults!.isEmpty && _hadithResults!.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                text: 'Quran (${_quranResults?.length ?? 0})',
              ),
              Tab(
                text: 'Hadith (${_hadithResults?.length ?? 0})',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildQuranResults(),
                _buildHadithResults(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuranResults() {
    if (_quranResults == null || _quranResults!.isEmpty) {
      return const Center(child: Text('No Quran results found'));
    }

    return ListView.builder(
      itemCount: _quranResults!.length,
      itemBuilder: (context, index) {
        final result = _quranResults![index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: ListTile(
            title: Text(
              result['text'],
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Scheherazade',
              ),
              textDirection: TextDirection.rtl,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text(result['translation']),
                Text(
                  'Surah ${result['surah']}, Ayah ${result['ayah']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuranReader(
                    surahNumber: result['surah'],
                    initialAyah: result['ayah'],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHadithResults() {
    if (_hadithResults == null || _hadithResults!.isEmpty) {
      return const Center(child: Text('No Hadith results found'));
    }

    return ListView.builder(
      itemCount: _hadithResults!.length,
      itemBuilder: (context, index) {
        final result = _hadithResults![index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${result['collection']} - Hadith ${result['number']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.bookmark_outline),
                      onPressed: () {
                        // Implement bookmarking
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  result['arabic'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Scheherazade',
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const Divider(height: 16),
                Text(result['translation']),
                if (result['grade'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Grade: ${result['grade']}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search Quran and Hadith...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _quranResults = null;
                _hadithResults = null;
              });
            },
          ),
        ],
      ),
      body: _buildSearchResults(),
    );
  }
}
