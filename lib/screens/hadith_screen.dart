import 'package:flutter/material.dart';
import '../services/hadith_service.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  final HadithService _hadithService = HadithService();
  List<Map<String, dynamic>>? _collections;
  Map<String, dynamic>? _selectedCollection;
  List<Map<String, dynamic>>? _hadiths;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCollections();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreHadiths();
    }
  }

  Future<void> _loadCollections() async {
    try {
      final collections = await _hadithService.getHadithCollections();
      setState(() => _collections = collections);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading collections: $e')),
        );
      }
    }
  }

  Future<void> _loadHadithsFromCollection(
      Map<String, dynamic> collection) async {
    setState(() {
      _selectedCollection = collection;
      _hadiths = null;
      _currentPage = 1;
      _hasMore = true;
    });
    await _loadMoreHadiths();
  }

  Future<void> _loadMoreHadiths() async {
    if (_isLoading || !_hasMore || _selectedCollection == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await _hadithService.getHadithsFromCollection(
        _selectedCollection!['id'],
        _currentPage,
      );

      setState(() {
        if (_hadiths == null) {
          _hadiths = result['hadiths'];
        } else {
          _hadiths!.addAll(result['hadiths']);
        }
        _currentPage++;
        _hasMore = result['hasMore'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading hadiths: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadith Collections'),
      ),
      body: _collections == null
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                SizedBox(
                  width: 200,
                  child: ListView.builder(
                    itemCount: _collections!.length,
                    itemBuilder: (context, index) {
                      final collection = _collections![index];
                      final isSelected =
                          collection['id'] == _selectedCollection?['id'];

                      return ListTile(
                        title: Text(
                          collection['name'],
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          '${collection['totalHadiths']} hadiths',
                        ),
                        selected: isSelected,
                        onTap: () => _loadHadithsFromCollection(collection),
                      );
                    },
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _selectedCollection == null
                      ? const Center(
                          child: Text('Select a collection to view hadiths'),
                        )
                      : _hadiths == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: _hadiths!.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _hadiths!.length) {
                                  return Center(
                                    child: _isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.all(16),
                                            child: CircularProgressIndicator(),
                                          )
                                        : _hasMore
                                            ? TextButton(
                                                onPressed: _loadMoreHadiths,
                                                child: const Text('Load more'),
                                              )
                                            : const Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Text('No more hadiths'),
                                              ),
                                  );
                                }

                                final hadith = _hadiths![index];
                                return Card(
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                'Hadith ${hadith['number']}',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.bookmark_outline),
                                              onPressed: () {
                                                // Implement bookmarking
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.share),
                                              onPressed: () {
                                                // Implement sharing
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          hadith['arabic'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Scheherazade',
                                          ),
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        const Divider(height: 32),
                                        Text(hadith['translation']),
                                        if (hadith['grade'] != null) ...[
                                          const SizedBox(height: 16),
                                          Text(
                                            'Grade: ${hadith['grade']}',
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
                            ),
                ),
              ],
            ),
    );
  }
}
