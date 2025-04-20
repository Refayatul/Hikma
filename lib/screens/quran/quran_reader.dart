import 'package:flutter/material.dart';
import '../../services/quran_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranReader extends StatefulWidget {
  final int surahNumber;
  final int initialAyah;

  const QuranReader({
    super.key,
    required this.surahNumber,
    this.initialAyah = 1,
  });

  @override
  State<QuranReader> createState() => _QuranReaderState();
}

class _QuranReaderState extends State<QuranReader> {
  final QuranService _quranService = QuranService();
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? _surahData;
  Map<String, dynamic>? _translation;
  Map<String, dynamic>? _transliteration;
  bool _showTranslation = true;
  bool _showTransliteration = true;
  double _audioSpeed = 1.0;
  bool _isLooping = false;

  @override
  void initState() {
    super.initState();
    _loadSurah();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showTranslation = prefs.getBool('showTranslation') ?? true;
      _showTransliteration = prefs.getBool('showTransliteration') ?? true;
      _audioSpeed = prefs.getDouble('audioSpeed') ?? 1.0;
    });
  }

  Future<void> _loadSurah() async {
    try {
      final surah = await _quranService.getSurah(widget.surahNumber);
      final translation = await _quranService.getTranslation(
        widget.surahNumber,
        'en',
      );
      final transliteration = await _quranService.getTransliteration(
        widget.surahNumber,
      );

      setState(() {
        _surahData = surah;
        _translation = translation;
        _transliteration = transliteration;
      });

      if (widget.initialAyah > 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToAyah(widget.initialAyah);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading surah: $e')),
        );
      }
    }
  }

  void _scrollToAyah(int ayahNumber) {
    if (_scrollController.hasClients) {
      final offset = (ayahNumber - 1) * 100.0; // Approximate height per ayah
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_surahData == null ||
        _translation == null ||
        _transliteration == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_surahData!['name']),
        actions: [
          PopupMenuButton<double>(
            icon: const Icon(Icons.speed),
            onSelected: (speed) async {
              setState(() => _audioSpeed = speed);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setDouble('audioSpeed', speed);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 0.5, child: Text('0.5x')),
              const PopupMenuItem(value: 0.75, child: Text('0.75x')),
              const PopupMenuItem(value: 1.0, child: Text('1.0x')),
              const PopupMenuItem(value: 1.25, child: Text('1.25x')),
              const PopupMenuItem(value: 1.5, child: Text('1.5x')),
            ],
          ),
          IconButton(
            icon: Icon(_showTransliteration ? Icons.abc : Icons.abc_outlined),
            onPressed: () async {
              setState(() => _showTransliteration = !_showTransliteration);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('showTransliteration', _showTransliteration);
            },
          ),
          IconButton(
            icon: Icon(
              _showTranslation ? Icons.translate : Icons.block,
            ),
            onPressed: () async {
              setState(() => _showTranslation = !_showTranslation);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('showTranslation', _showTranslation);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () async {
              await _quranService.saveBookmark(widget.surahNumber, 1);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bookmark saved')),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _surahData!['ayahs'].length,
        itemBuilder: (context, index) {
          final ayah = _surahData!['ayahs'][index];
          final translation = _translation!['ayahs'][index];
          final transliteration = _transliteration!['ayahs'][index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${index + 1}'),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          _quranService.currentAyahPlaying == index + 1
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          if (_quranService.currentAyahPlaying == index + 1) {
                            if (_quranService.isPlaying) {
                              _quranService.pauseAudio();
                            } else {
                              _quranService.resumeAudio();
                            }
                          } else {
                            _quranService.playAudio(
                              widget.surahNumber,
                              index + 1,
                              speed: _audioSpeed,
                            );
                          }
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(_isLooping &&
                                _quranService.currentAyahPlaying == index + 1
                            ? Icons.repeat_one
                            : Icons.repeat),
                        onPressed: () {
                          setState(() => _isLooping = !_isLooping);
                          // Implement looping logic
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ayah['text'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Scheherazade',
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  if (_showTransliteration) ...[
                    const SizedBox(height: 8),
                    Text(
                      transliteration['text'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (_showTranslation) ...[
                    const Divider(),
                    Text(
                      translation['text'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
