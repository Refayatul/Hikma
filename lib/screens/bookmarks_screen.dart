import 'package:flutter/material.dart';
import '../services/quran_service.dart';
import '../services/hadith_bookmark_service.dart';
import 'quran/quran_reader.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final QuranService _quranService = QuranService();
  final HadithBookmarkService _hadithBookmarkService = HadithBookmarkService();
  Map<String, int>? _quranBookmark;
  List<Map<String, dynamic>>? _hadithBookmarks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookmarks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    final quranBookmark = await _quranService.getLastBookmark();
    final hadithBookmarks = await _hadithBookmarkService.getBookmarks();

    if (mounted) {
      setState(() {
        _quranBookmark = quranBookmark;
        _hadithBookmarks = hadithBookmarks;
      });
    }
  }

  Widget _buildQuranBookmarks() {
    if (_quranBookmark == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_quranBookmark!['surah'] == null) {
      return const Center(
        child: Text('No Quran bookmarks yet'),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        title: const Text('Last Read'),
        subtitle: Text(
          'Surah ${_quranBookmark!['surah']}, Ayah ${_quranBookmark!['ayah']}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuranReader(
                surahNumber: _quranBookmark!['surah']!,
                initialAyah: _quranBookmark!['ayah']!,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHadithBookmarks() {
    if (_hadithBookmarks == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hadithBookmarks!.isEmpty) {
      return const Center(
        child: Text('No hadith bookmarks yet'),
      );
    }

    return ListView.builder(
      itemCount: _hadithBookmarks!.length,
      itemBuilder: (context, index) {
        final hadith = _hadithBookmarks![index];
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
                      '${hadith['collection']} - Hadith ${hadith['number']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await _hadithBookmarkService.removeBookmark(
                          hadith['collection'],
                          hadith['number'],
                        );
                        _loadBookmarks();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  hadith['arabic'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Scheherazade',
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const Divider(height: 16),
                Text(hadith['translation']),
                if (hadith['grade'] != null) ...[
                  const SizedBox(height: 8),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Quran'),
            Tab(text: 'Hadith'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQuranBookmarks(),
          _buildHadithBookmarks(),
        ],
      ),
    );
  }
}
