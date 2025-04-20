import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getDailyQuiz() async {
    try {
      // Get today's quiz, limiting to 10 questions
      final snapshot = await _firestore
          .collection('quizzes')
          .where('date',
              isEqualTo: DateTime.now().toIso8601String().split('T')[0])
          .limit(10)
          .get();

      if (snapshot.docs.isEmpty) {
        // If no quiz for today, get random questions
        return getRandomQuiz();
      }

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to load daily quiz: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRandomQuiz() async {
    try {
      final snapshot = await _firestore
          .collection('quizzes')
          .orderBy(FieldPath.documentId)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to load random quiz: $e');
    }
  }

  Future<void> submitQuizScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final highScore = prefs.getInt('quiz_high_score') ?? 0;
      if (score > highScore) {
        await prefs.setInt('quiz_high_score', score);
      }

      final totalQuizzes = prefs.getInt('total_quizzes_taken') ?? 0;
      await prefs.setInt('total_quizzes_taken', totalQuizzes + 1);

      // Update leaderboard in Firestore
      await _firestore.collection('leaderboard').add({
        'score': score,
        'date': DateTime.now().toIso8601String(),
        'deviceId': prefs.getString('device_id'),
      });
    } catch (e) {
      throw Exception('Failed to submit quiz score: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    try {
      final snapshot = await _firestore
          .collection('leaderboard')
          .orderBy('score', descending: true)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to load leaderboard: $e');
    }
  }

  Future<Map<String, dynamic>> getQuizStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'highScore': prefs.getInt('quiz_high_score') ?? 0,
      'totalQuizzes': prefs.getInt('total_quizzes_taken') ?? 0,
    };
  }
}
