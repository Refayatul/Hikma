import 'package:flutter/material.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surah List'),
      ),
      body: const Center(
        child: Text('Surah List Screen'),
      ),
    );
  }
}
