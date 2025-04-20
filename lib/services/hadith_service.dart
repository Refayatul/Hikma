import 'package:http/http.dart' as http;
import 'dart:convert';

class HadithService {
  static const String baseUrl = 'https://api.sunnah.com/v1';

  Future<List<Map<String, dynamic>>> getHadithCollections() async {
    final response = await http.get(
      Uri.parse('$baseUrl/collections'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    }
    throw Exception('Failed to load hadith collections');
  }

  Future<Map<String, dynamic>> getHadithsFromCollection(
    String collection,
    int page, {
    int limit = 20,
  }) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/collections/$collection/hadiths?page=$page&limit=$limit'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'hadiths': List<Map<String, dynamic>>.from(data['data']),
        'hasMore': data['meta']['total'] > page * limit,
      };
    }
    throw Exception('Failed to load hadiths');
  }

  Future<Map<String, dynamic>> getHadithDetails(
    String collection,
    int hadithNumber,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/collections/$collection/hadiths/$hadithNumber'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    throw Exception('Failed to load hadith details');
  }

  Future<Map<String, dynamic>> searchHadiths(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search?q=${Uri.encodeComponent(query)}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'results': List<Map<String, dynamic>>.from(data['data']),
        'total': data['meta']['total'],
      };
    }
    throw Exception('Failed to search hadiths');
  }

  Future<List<Map<String, dynamic>>> getHadithsByTopic(String topic) async {
    final response = await http.get(
      Uri.parse('$baseUrl/topics/$topic/hadiths'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    }
    throw Exception('Failed to load hadiths by topic');
  }

  Future<List<Map<String, dynamic>>> getHadithChapters(
      String collection) async {
    final response = await http.get(
      Uri.parse('$baseUrl/collections/$collection/chapters'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    }
    throw Exception('Failed to load hadith chapters');
  }

  Future<List<Map<String, dynamic>>> getRelatedHadiths(
    String collection,
    int hadithNumber,
  ) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/collections/$collection/hadiths/$hadithNumber/related'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    }
    throw Exception('Failed to load related hadiths');
  }
}
