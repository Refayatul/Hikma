// import 'package:groq_sdk/groq_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  // static final Groq _client = Groq(apiKey: dotenv.env['GROQ_API_KEY'] ?? '');

  /*
  static Stream<String> generateIslamicResponse(String query) async* {
    try {
      final chatCompletion = await _client.chat.completions.create(
        model: "deepseek-r1-distill-llama-70b",
        messages: [
          {
            "role": "system",
            "content": "You are an Islamic knowledge assistant. Answer with: "
                "1. Concise ruling 2. Quran/Hadith evidence 3. Major madhab opinions. "
                "Always add: 'Please consult a local scholar for personal matters.'"
          },
          {"role": "user", "content": query}
        ],
        temperature: 0.6,
        maxTokens: 4096,
        topP: 0.95,
        stream: true,
      );

      await for (final chunk in chatCompletion) {
        yield chunk.choices.first.delta.content ?? '';
      }
    } catch (e) {
      yield "Error generating response: \$e\nPlease try again later.";
    }
  }

  static Future<String> generateTafsir(String verseReference) async {
    try {
      final completion = await _client.completions.create(
        model: "deepseek-r1-distill-llama-70b",
        messages: [
          {
            "role": "system",
            "content":
                "You are a Quran Tafsir specialist. Provide concise, accurate explanations."
          },
          {
            "role": "user",
            "content": "Explain Quran $verseReference in 3 points:\n"
                "1. Linguistic meaning\n2. Historical context\n3. Modern application"
          }
        ],
        temperature: 0.4,
        stream: false,
      );

      return completion.choices.first.message.content ??
          'Unable to generate tafsir';
    } catch (e) {
      return "Error generating tafsir: \$e\nPlease try again later.";
    }
  }

  static Future<List<Map<String, dynamic>>> generateQuizQuestions(
      String topic) async {
    try {
      final completion = await _client.completions.create(
        model: "deepseek-r1-distill-llama-70b",
        messages: [
          {
            "role": "system",
            "content":
                "Generate Islamic quiz questions in a structured JSON format."
          },
          {
            "role": "user",
            "content": "Generate 5 multiple choice questions about $topic. "
                "Include question, 4 options, correct answer index, and explanation."
          }
        ],
        temperature: 0.7,
        stream: false,
      );

      final response = completion.choices.first.message.content ?? '[]';
      // Note: You'll need to parse the JSON response and handle it appropriately
      return []; // Replace with actual JSON parsing
    } catch (e) {
      return [];
    }
  }
  */
}
