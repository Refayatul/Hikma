import 'local_storage_service.dart';

class HadithBookmarkService {
  Future<List<Map<String, dynamic>>> getBookmarks() async {
    return LocalStorageService.getBookmarks('hadith');
  }

  Future<void> addBookmark(Map<String, dynamic> hadith) async {
    final bookmarks = await getBookmarks();

    // Check if already bookmarked
    if (bookmarks.any((b) =>
        b['collection'] == hadith['collection'] &&
        b['number'] == hadith['number'])) {
      return;
    }

    final bookmarkData = {
      'collection': hadith['collection'],
      'number': hadith['number'],
      'arabic': hadith['arabic'],
      'translation': hadith['translation'],
      'grade': hadith['grade'],
      'timestamp': DateTime.now().toIso8601String(),
    };

    await LocalStorageService.addBookmark(
      'hadith',
      '${hadith['collection']}_${hadith['number']}',
      bookmarkData,
    );
  }

  Future<void> removeBookmark(String collection, int number) async {
    await LocalStorageService.removeBookmark(
      'hadith',
      '${collection}_$number',
    );
  }

  Future<bool> isBookmarked(String collection, int number) async {
    final bookmarks = await getBookmarks();
    return bookmarks
        .any((b) => b['collection'] == collection && b['number'] == number);
  }
}
