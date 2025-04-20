import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class PrayerJournalScreen extends StatefulWidget {
  const PrayerJournalScreen({super.key});

  @override
  State<PrayerJournalScreen> createState() => _PrayerJournalScreenState();
}

class _PrayerJournalScreenState extends State<PrayerJournalScreen> {
  final List<String> _prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  final List<String> _moods = ['😊', '😌', '😔', '😟', '😤'];

  Map<String, bool> _todaysPrayers = {};
  String? _todaysMood;
  int _streak = 0;
  List<Map<String, dynamic>> _journalEntries = [];
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJournalData();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadJournalData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];

    setState(() {
      // Load today's prayers
      for (final prayer in _prayerNames) {
        _todaysPrayers[prayer] =
            prefs.getBool('prayer_${today}_$prayer') ?? false;
      }

      // Load today's mood
      _todaysMood = prefs.getString('mood_$today');

      // Load streak
      _streak = prefs.getInt('prayer_streak') ?? 0;

      // Load journal entries
      final entriesJson = prefs.getString('journal_entries') ?? '[]';
      _journalEntries = List<Map<String, dynamic>>.from(
        json.decode(entriesJson).map((x) => Map<String, dynamic>.from(x)),
      );
    });
  }

  Future<void> _saveJournalData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];

    // Save prayers
    for (final entry in _todaysPrayers.entries) {
      await prefs.setBool('prayer_${today}_${entry.key}', entry.value);
    }

    // Save mood
    if (_todaysMood != null) {
      await prefs.setString('mood_$today', _todaysMood!);
    }

    // Calculate and save streak
    final allPrayersCompleted = _todaysPrayers.values.every((done) => done);
    if (allPrayersCompleted) {
      await prefs.setInt('prayer_streak', _streak + 1);
    } else if (_streak > 0) {
      await prefs.setInt('prayer_streak', 0);
    }

    // Save journal entries
    await prefs.setString('journal_entries', json.encode(_journalEntries));
  }

  Future<void> _addJournalEntry() async {
    if (_noteController.text.isEmpty) return;

    setState(() {
      _journalEntries.insert(0, {
        'date': DateTime.now().toIso8601String(),
        'note': _noteController.text,
        'mood': _todaysMood,
        'prayers': Map<String, bool>.from(_todaysPrayers),
      });
      _noteController.clear();
    });

    await _saveJournalData();
  }

  void _exportJournal() {
    // TODO: Implement export functionality
    // This would generate a PDF or text file with all journal entries
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportJournal,
            tooltip: 'Export Journal',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prayer Streak',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_streak days',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  ..._prayerNames.map((prayer) => CheckboxListTile(
                        title: Text(prayer),
                        value: _todaysPrayers[prayer] ?? false,
                        onChanged: (value) {
                          setState(
                              () => _todaysPrayers[prayer] = value ?? false);
                          _saveJournalData();
                        },
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Mood',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _moods
                        .map((mood) => GestureDetector(
                              onTap: () {
                                setState(() => _todaysMood = mood);
                                _saveJournalData();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _todaysMood == mood
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1)
                                      : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  mood,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Journal Entry',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Write your thoughts about today\'s prayers...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _addJournalEntry,
                      child: const Text('Add Entry'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_journalEntries.isNotEmpty) ...[
            Text(
              'Previous Entries',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...List.generate(
              _journalEntries.length,
              (index) {
                final entry = _journalEntries[index];
                final date = DateTime.parse(entry['date']);
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(DateFormat('MMM d, y').format(date)),
                    subtitle: Text(entry['note']),
                    trailing: Text(
                      entry['mood'] ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
