import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService();
  List<Map<String, dynamic>>? _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswerIndex;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    try {
      final questions = await _quizService.getDailyQuiz();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading quiz: $e')),
        );
      }
    }
  }

  void _handleAnswer(int index) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswerIndex = index;

      if (_questions![_currentQuestionIndex]['correct_index'] == index) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestionIndex < (_questions?.length ?? 0) - 1) {
        setState(() {
          _currentQuestionIndex++;
          _answered = false;
          _selectedAnswerIndex = null;
        });
      } else {
        _showResults();
      }
    });
  }

  void _showResults() async {
    try {
      await _quizService.submitQuizScore(_score);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(
              score: _score,
              totalQuestions: _questions?.length ?? 0,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting score: $e')),
        );
      }
    }
  }

  Color _getOptionColor(int index) {
    if (!_answered) return Colors.grey[200]!;

    if (_questions![_currentQuestionIndex]['correct_index'] == index) {
      return Colors.green[100]!;
    }

    if (_selectedAnswerIndex == index) {
      return Colors.red[100]!;
    }

    return Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions == null || _questions!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    final question = _questions![_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Islamic Quiz'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Score: $_score',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions!.length,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 24),
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions!.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              question['question'],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            ...List.generate(
              question['options'].length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: _answered ? null : () => _handleAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getOptionColor(index),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(
                    question['options'][index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            if (_answered && _selectedAnswerIndex != null) ...[
              const SizedBox(height: 24),
              Text(
                question['explanation'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
