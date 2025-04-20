import 'package:flutter/material.dart';
import '../services/groq_service.dart';

class AIQAScreen extends StatefulWidget {
  const AIQAScreen({super.key});

  @override
  State<AIQAScreen> createState() => _AIQAScreenState();
}

class _AIQAScreenState extends State<AIQAScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<Map<String, String>> _chatHistory = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _askQuestion() async {
    if (_questionController.text.trim().isEmpty) return;

    final question = _questionController.text.trim();
    setState(() {
      _chatHistory.add({
        'role': 'user',
        'content': question,
      });
      _isLoading = true;
    });
    _questionController.clear();

    // String fullResponse = '';
    // await for (final chunk in GroqService.generateIslamicResponse(question)) {
    //   setState(() {
    //     if (_chatHistory.last['role'] == 'assistant') {
    //       _chatHistory.last['content'] =
    //           (_chatHistory.last['content'] ?? '') + chunk;
    //     } else {
    //       _chatHistory.add({
    //         'role': 'assistant',
    //         'content': chunk,
    //       });
    //     }
    //   });
    // }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Islamic Questions'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final message = _chatHistory[_chatHistory.length - 1 - index];
                final isUser = message['role'] == 'user';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: Text(
                        message['content'] ?? '',
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      hintText: 'Ask an Islamic question...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _askQuestion(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _askQuestion,
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
