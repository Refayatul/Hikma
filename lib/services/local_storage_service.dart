import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  // Get Hive boxes
  static Box get bookmarksBox => Hive.box('bookmarks');
  static Box get prayerJournalBox => Hive.box('prayerJournal');
  static Box get quranProgressBox => Hive.box('quranProgress');
  static Box get duasBox => Hive.box('duas');
  static Box get hadithBox => Hive.box('hadith');

  // Bookmarks
  static Future<void> addBookmark(
      String type, String id, Map<String, dynamic> data) async {
    final box = bookmarksBox;
    final bookmarks = box.get(type, defaultValue: []) as List;
    if (!bookmarks.any((bookmark) => bookmark['id'] == id)) {
      bookmarks.add({'id': id, ...data});
      await box.put(type, bookmarks);
    }
  }

  static Future<void> removeBookmark(String type, String id) async {
    final box = bookmarksBox;
    final bookmarks = box.get(type, defaultValue: []) as List;
    bookmarks.removeWhere((bookmark) => bookmark['id'] == id);
    await box.put(type, bookmarks);
  }

  static List<Map<String, dynamic>> getBookmarks(String type) {
    final box = bookmarksBox;
    final bookmarks = box.get(type, defaultValue: []) as List;
    return bookmarks.cast<Map<String, dynamic>>();
  }

  // Prayer Journal
  static Future<void> addPrayerEntry(Map<String, dynamic> entry) async {
    final box = prayerJournalBox;
    final entries = box.get('entries', defaultValue: []) as List;
    entries.add(entry);
    await box.put('entries', entries);
  }

  static List<Map<String, dynamic>> getPrayerEntries() {
    final box = prayerJournalBox;
    final entries = box.get('entries', defaultValue: []) as List;
    return entries.cast<Map<String, dynamic>>();
  }

  // Quran Progress
  static Future<void> updateQuranProgress(int surah, int ayah) async {
    await quranProgressBox.put('lastRead', {'surah': surah, 'ayah': ayah});
  }

  static Map<String, dynamic>? getQuranProgress() {
    final progress = quranProgressBox.get('lastRead');
    return progress != null ? Map<String, dynamic>.from(progress) : null;
  }

  // Duas
  static Future<void> saveDua(String id, Map<String, dynamic> dua) async {
    await duasBox.put(id, dua);
  }

  static Map<String, dynamic>? getDua(String id) {
    final dua = duasBox.get(id);
    return dua != null ? Map<String, dynamic>.from(dua) : null;
  }

  static List<Map<String, dynamic>> getAllDuas() {
    return duasBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // Hadith
  static Future<void> saveHadith(String id, Map<String, dynamic> hadith) async {
    await hadithBox.put(id, hadith);
  }

  static Map<String, dynamic>? getHadith(String id) {
    final hadith = hadithBox.get(id);
    return hadith != null ? Map<String, dynamic>.from(hadith) : null;
  }

  static List<Map<String, dynamic>> getAllHadith() {
    return hadithBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await Future.wait([
      bookmarksBox.clear(),
      prayerJournalBox.clear(),
      quranProgressBox.clear(),
      duasBox.clear(),
      hadithBox.clear(),
    ]);
  }
}
