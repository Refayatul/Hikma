import 'package:flutter/material.dart';
import '../services/prayer_tracker_service.dart';
import 'package:table_calendar/table_calendar.dart';

class PrayerTrackingScreen extends StatefulWidget {
  const PrayerTrackingScreen({super.key});

  @override
  State<PrayerTrackingScreen> createState() => _PrayerTrackingScreenState();
}

class _PrayerTrackingScreenState extends State<PrayerTrackingScreen> {
  final PrayerTrackerService _trackerService = PrayerTrackerService();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  Map<String, dynamic> _monthStats = {};
  Map<String, dynamic> _prayerHistory = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final history = await _trackerService.getPrayerHistory();
    final stats = await _trackerService.getPrayerStatsForMonth(_focusedDate);
    if (mounted) {
      setState(() {
        _prayerHistory = history;
        _monthStats = stats;
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDate = focusedDay;
    });
    _showPrayerStatusDialog(selectedDay);
  }

  void _showPrayerStatusDialog(DateTime date) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final dayPrayers = _prayerHistory[dateStr] ?? {};

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Prayer Status - ${date.day}/${date.month}/${date.year}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPrayerStatusItem('Fajr', dayPrayers['fajr']),
            _buildPrayerStatusItem('Dhuhr', dayPrayers['dhuhr']),
            _buildPrayerStatusItem('Asr', dayPrayers['asr']),
            _buildPrayerStatusItem('Maghrib', dayPrayers['maghrib']),
            _buildPrayerStatusItem('Isha', dayPrayers['isha']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showUpdatePrayerDialog(date);
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerStatusItem(String prayer, Map<String, dynamic>? status) {
    IconData icon;
    Color color;
    String statusText;

    if (status == null) {
      icon = Icons.remove_circle_outline;
      color = Colors.grey;
      statusText = 'Not marked';
    } else if (status['done']) {
      icon = Icons.check_circle;
      color = status['isQadha'] ? Colors.orange : Colors.green;
      statusText = status['isQadha'] ? 'Qadha' : 'Completed';
    } else {
      icon = Icons.cancel;
      color = Colors.red;
      statusText = 'Missed';
    }

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(prayer),
      subtitle: Text(statusText),
      dense: true,
    );
  }

  void _showUpdatePrayerDialog(DateTime date) {
    final prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Prayer Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: prayers.map((prayer) {
            return ListTile(
              title: Text(prayer),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case 'done':
                      await _trackerService.markPrayerAsDone(
                        prayer.toLowerCase(),
                        date,
                      );
                      break;
                    case 'qadha':
                      await _trackerService.markPrayerAsDone(
                        prayer.toLowerCase(),
                        date,
                        isQadha: true,
                      );
                      break;
                    case 'missed':
                      await _trackerService.markPrayerAsMissed(
                        prayer.toLowerCase(),
                        date,
                      );
                      break;
                  }
                  await _loadData();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'done',
                    child: Text('Completed'),
                  ),
                  const PopupMenuItem(
                    value: 'qadha',
                    child: Text('Qadha'),
                  ),
                  const PopupMenuItem(
                    value: 'missed',
                    child: Text('Missed'),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  _monthStats['total']?.toString() ?? '0',
                  Icons.calendar_today,
                ),
                _buildStatItem(
                  'Completed',
                  _monthStats['completed']?.toString() ?? '0',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  'Missed',
                  _monthStats['missed']?.toString() ?? '0',
                  Icons.cancel,
                  Colors.red,
                ),
                _buildStatItem(
                  'Qadha',
                  _monthStats['qadha']?.toString() ?? '0',
                  Icons.update,
                  Colors.orange,
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Current Streak',
                  '${_monthStats['streak'] ?? 0} days',
                  Icons.local_fire_department,
                ),
                _buildStatItem(
                  'Longest Streak',
                  '${_monthStats['longestStreak'] ?? 0} days',
                  Icons.emoji_events,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon,
      [Color? color]) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStats(),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDate,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDate = focusedDay;
              });
              _loadData();
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final dateStr =
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                final prayers = _prayerHistory[dateStr];

                if (prayers == null) return null;

                final completed = prayers.values.where((p) => p['done']).length;
                final total = prayers.length;

                if (total == 0) return null;

                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 35,
                    height: 3,
                    color: completed == total
                        ? Colors.green
                        : completed == 0
                            ? Colors.red
                            : Colors.orange,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUpdatePrayerDialog(_selectedDate),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
