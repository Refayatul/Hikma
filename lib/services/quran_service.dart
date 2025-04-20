import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';
  static const String tanzilBaseUrl = 'https://api.tanzil.net/trans';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int? _currentAyahPlaying;

  Future<Map<String, dynamic>> getSurah(int number) async {
    final response = await http.get(
      Uri.parse('$baseUrl/surah/$number'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    throw Exception('Failed to load surah');
  }

  Future<Map<String, dynamic>> getTranslation(
    int surahNumber,
    String language,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/surah/$surahNumber/$language'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    throw Exception('Failed to load translation');
  }

  Future<Map<String, dynamic>> getTransliteration(int surahNumber) async {
    final response = await http.get(
      Uri.parse('$tanzilBaseUrl/1/$surahNumber'), // Using Tanzil's transliteration service
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load transliteration');
  }

  Future<void> playAudio(int surahNumber, int ayahNumber, {double speed = 1.0}) async {
    if (_isPlaying) {
      await stopAudio();
    }

    final url = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$ayahNumber.mp3';
    await _audioPlayer.setPlaybackRate(speed);
    await _audioPlayer.play(UrlSource(url));
    
    _isPlaying = true;
    _currentAyahPlaying = ayahNumber;

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _currentAyahPlaying = null;
    });
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> resumeAudio() async {
    await _audioPlayer.resume();
    _isPlaying = true;
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentAyahPlaying = null;
  }

  bool get isPlaying => _isPlaying;
  int? get currentAyahPlaying => _currentAyahPlaying;

  Future<void> saveBookmark(int surahNumber, int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSurah', surahNumber);
    await prefs.setInt('lastAyah', ayahNumber);
  }

  Future<Map<String, int>> getLastBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'surah': prefs.getInt('lastSurah') ?? 1,
      'ayah': prefs.getInt('lastAyah') ?? 1,
    };
  }

  Future<List<Map<String, dynamic>>> searchQuran(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/$query/all/en'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data['matches']);
    }
    throw Exception('Failed to search Quran');
  }

  Future<Map<String, dynamic>> getJuzInfo(int juzNumber) async {
    final response = await http.get(
      Uri.parse('$baseUrl/juz/$juzNumber'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    throw Exception('Failed to load juz information');
  }

  Future<List<Map<String, dynamic>>> getSurahList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/surah'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    }
    throw Exception('Failed to load surah list');
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
