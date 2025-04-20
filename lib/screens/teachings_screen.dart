import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeachingsScreen extends StatefulWidget {
  const TeachingsScreen({super.key});

  @override
  State<TeachingsScreen> createState() => _TeachingsScreenState();
}

class _TeachingsScreenState extends State<TeachingsScreen> {
  final Map<String, int> _dhikrCounts = {};
  final List<String> _commonDhikr = [
    'SubhanAllah',
    'Alhamdulillah',
    'Allahu Akbar',
    'Astaghfirullah',
    'La ilaha illallah',
  ];

  @override
  void initState() {
    super.initState();
    _loadDhikrCounts();
  }

  Future<void> _loadDhikrCounts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final dhikr in _commonDhikr) {
        _dhikrCounts[dhikr] = prefs.getInt('dhikr_$dhikr') ?? 0;
      }
    });
  }

  Future<void> _incrementDhikr(String dhikr) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dhikrCounts[dhikr] = (_dhikrCounts[dhikr] ?? 0) + 1;
    });
    await prefs.setInt('dhikr_$dhikr', _dhikrCounts[dhikr]!);
  }

  Future<void> _resetDhikr(String dhikr) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dhikrCounts[dhikr] = 0;
    });
    await prefs.setInt('dhikr_$dhikr', 0);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Islamic Teachings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Daily Reminders'),
              Tab(text: 'Dhikr Counter'),
              Tab(text: 'Articles'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDailyReminders(),
            _buildDhikrCounter(),
            _buildArticles(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyReminders() {
    final reminders = [
      {
        'title': 'Morning Adhkar',
        'time': 'After Fajr',
        'description': 'Start your day with morning remembrance',
      },
      {
        'title': 'Evening Adhkar',
        'time': 'After Asr',
        'description': 'End your day with evening remembrance',
      },
      {
        'title': 'Dua Before Meals',
        'time': 'Before eating',
        'description': 'Bismillah wa ala barakatillah',
      },
      {
        'title': 'Sleep Duas',
        'time': 'Before sleeping',
        'description': 'Recommended duas before sleeping',
      },
    ];

    return ListView.builder(
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(reminder['title']!),
            subtitle: Text(reminder['time']!),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to detailed reminder screen
            },
          ),
        );
      },
    );
  }

  Widget _buildDhikrCounter() {
    return ListView.builder(
      itemCount: _commonDhikr.length,
      itemBuilder: (context, index) {
        final dhikr = _commonDhikr[index];
        final count = _dhikrCounts[dhikr] ?? 0;

        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  dhikr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: const TextStyle(fontSize: 48),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _incrementDhikr(dhikr),
                      child: const Text('Add'),
                    ),
                    TextButton(
                      onPressed: () => _resetDhikr(dhikr),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArticles() {
    final articles = [
      {
        'title': 'The Five Pillars of Islam',
        'category': 'Basics',
        'readTime': '5 min',
      },
      {
        'title': 'Understanding Ramadan',
        'category': 'Worship',
        'readTime': '7 min',
      },
      {
        'title': 'The Importance of Good Character',
        'category': 'Ethics',
        'readTime': '4 min',
      },
      {
        'title': 'Islamic History: The Prophet\'s Life',
        'category': 'History',
        'readTime': '10 min',
      },
    ];

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(article['title']!),
            subtitle: Text(article['category']!),
            trailing: Text(article['readTime']!),
            onTap: () {
              // Navigate to article detail screen
            },
          ),
        );
      },
    );
  }
}
