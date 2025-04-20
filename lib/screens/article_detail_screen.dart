import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String category;
  final String content;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.category,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement sharing functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              // Implement bookmarking functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Markdown(
              data: content,
              styleSheet: MarkdownStyleSheet(
                h1: Theme.of(context).textTheme.headlineMedium,
                h2: Theme.of(context).textTheme.titleLarge,
                p: Theme.of(context).textTheme.bodyLarge,
              ),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement text-to-speech functionality
        },
        child: const Icon(Icons.volume_up),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'basics':
        return Icons.school;
      case 'worship':
        return Icons.mosque;
      case 'ethics':
        return Icons.people;
      case 'history':
        return Icons.history_edu;
      default:
        return Icons.article;
    }
  }
}
