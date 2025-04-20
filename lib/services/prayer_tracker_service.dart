import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PrayerTrackerService {
  static const String PRAYER_HISTORY_KEY = 'prayer_history';

  Future<void> markPrayerAsDone(String prayer, DateTime date,
      {bool isQadha = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getPrayerHistory();

    final dateStr = _formatDate(date);
    if (!history.containsKey(dateStr)) {
      history[dateStr] = {};
    }

    history[dateStr][prayer] = {
      'done': true,
      'time': date.toIso8601String(),
      'isQadha': isQadha,
    };

    await prefs.setString(PRAYER_HISTORY_KEY, json.encode(history));
  }

  Future<void> markPrayerAsMissed(String prayer, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getPrayerHistory();

    final dateStr = _formatDate(date);
    if (!history.containsKey(dateStr)) {
      history[dateStr] = {};
    }

    history[dateStr][prayer] = {
      'done': false,
      'time': date.toIso8601String(),
    };

    await prefs.setString(PRAYER_HISTORY_KEY, json.encode(history));
  }

  Future<Map<String, dynamic>> getPrayerHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyStr = prefs.getString(PRAYER_HISTORY_KEY);
    if (historyStr == null) return {};
    return json.decode(historyStr);
  }

  Future<Map<String, dynamic>> getPrayerStatsForMonth(DateTime month) async {
    final history = await getPrayerHistory();
    final stats = {
      'total': 0,
      'completed': 0,
      'missed': 0,
      'qadha': 0,
      'streak': 0,
      'longestStreak': 0,
    };

    var currentStreak = 0;
    var date = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    while (date.isBefore(lastDay) || date.isAtSameMomentAs(lastDay)) {
      final dateStr = _formatDate(date);
      final dayPrayers = history[dateStr] ?? {};

      var allPrayersCompleted = true;
      var hasPrayers = false;

      for (var prayer in ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha']) {
        if (dayPrayers.containsKey(prayer)) {
          hasPrayers = true;
          stats['total'] = (stats['total'] ?? 0) + 1;

          if (dayPrayers[prayer]['done']) {
            stats['completed'] = (stats['completed'] ?? 0) + 1;
            if (dayPrayers[prayer]['isQadha'] == true) {
              stats['qadha'] = (stats['qadha'] ?? 0) + 1;
            }
          } else {
            stats['missed'] = (stats['missed'] ?? 0) + 1;
            allPrayersCompleted = false;
          }
        }
      }

      if (hasPrayers && allPrayersCompleted) {
        currentStreak++;
        stats['longestStreak'] = currentStreak > (stats['longestStreak'] ?? 0)
            ? currentStreak
            : stats['longestStreak'] ?? 0;
      } else if (hasPrayers) {
        currentStreak = 0;
      }

      date = date.add(const Duration(days: 1));
    }

    stats['streak'] = currentStreak;
    return stats;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PRAYER_HISTORY_KEY);
  }
}
