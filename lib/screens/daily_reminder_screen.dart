import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class DailyReminderScreen extends StatefulWidget {
  final String category; // 'morning', 'evening', 'meal', or 'sleep'

  const DailyReminderScreen({
    super.key,
    required this.category,
  });

  @override
  State<DailyReminderScreen> createState() => _DailyReminderScreenState();
}

class _DailyReminderScreenState extends State<DailyReminderScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, int> _completedCounts = {};
  bool _showTranslation = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedCounts();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadCompletedCounts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final dhikr in _getDhikrList()) {
        _completedCounts[dhikr['arabic']] =
            prefs.getInt('${widget.category}_${dhikr['arabic']}') ?? 0;
      }
    });
  }

  Future<void> _incrementCount(String dhikr) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _completedCounts[dhikr] = (_completedCounts[dhikr] ?? 0) + 1;
    });
    await prefs.setInt(
      '${widget.category}_$dhikr',
      _completedCounts[dhikr]!,
    );
  }

  Future<void> _resetCount(String dhikr) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _completedCounts[dhikr] = 0;
    });
    await prefs.setInt('${widget.category}_$dhikr', 0);
  }

  List<Map<String, dynamic>> _getDhikrList() {
    switch (widget.category) {
      case 'morning':
        return [
          {
            'arabic': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
            'transliteration': 'Asbahna wa asbahal mulku lillah',
            'translation':
                'We have reached the morning and dominion belongs to Allah',
            'repetitions': 1,
            'audioFile': 'morning_1.mp3',
          },
          {
            'arabic': 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا',
            'transliteration': 'Allahumma bika asbahna, wa bika amsayna',
            'translation':
                'O Allah, by You we enter the morning and by You we enter the evening',
            'repetitions': 1,
            'audioFile': 'morning_2.mp3',
          },
          // Add more morning adhkar
        ];
      case 'evening':
        return [
          {
            'arabic': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
            'transliteration': 'Amsayna wa amsal mulku lillah',
            'translation':
                'We have reached the evening and dominion belongs to Allah',
            'repetitions': 1,
            'audioFile': 'evening_1.mp3',
          },
          // Add more evening adhkar
        ];
      case 'meal':
        return [
          {
            'arabic': 'بِسْمِ اللَّهِ',
            'transliteration': 'Bismillah',
            'translation': 'In the name of Allah',
            'repetitions': 1,
            'audioFile': 'meal_1.mp3',
          },
          // Add more meal duas
        ];
      case 'sleep':
        return [
          {
            'arabic': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
            'transliteration': 'Bismika Allahumma amootu wa ahya',
            'translation': 'In Your name, O Allah, I die and I live',
            'repetitions': 1,
            'audioFile': 'sleep_1.mp3',
          },
          // Add more sleep duas
        ];
      default:
        return [];
    }
  }

  String _getCategoryTitle() {
    switch (widget.category) {
      case 'morning':
        return 'Morning Adhkar';
      case 'evening':
        return 'Evening Adhkar';
      case 'meal':
        return 'Meal Duas';
      case 'sleep':
        return 'Sleep Duas';
      default:
        return 'Duas';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCategoryTitle()),
        actions: [
          IconButton(
            icon: Icon(
              _showTranslation ? Icons.translate : Icons.block,
            ),
            onPressed: () {
              setState(() {
                _showTranslation = !_showTranslation;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _getDhikrList().length,
        itemBuilder: (context, index) {
          final dhikr = _getDhikrList()[index];
          final count = _completedCounts[dhikr['arabic']] ?? 0;
          final remaining = dhikr['repetitions'] - count;

          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    dhikr['arabic'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Scheherazade',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  if (_showTranslation) ...[
                    const SizedBox(height: 8),
                    Text(
                      dhikr['transliteration'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(dhikr['translation']),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remaining: $remaining/${dhikr['repetitions']}',
                        style: TextStyle(
                          color: remaining > 0 ? Colors.orange : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              // Play audio for this dhikr
                              // _audioPlayer.play(AssetSource(dhikr['audioFile']));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: remaining > 0
                                ? () => _incrementCount(dhikr['arabic'])
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: count > 0
                                ? () => _resetCount(dhikr['arabic'])
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
