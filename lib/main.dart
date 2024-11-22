import 'package:flutter/material.dart';
import 'package:salah/prayer_button.dart';


void main() {
  runApp(const StartScreen());
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Salah',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Daily Salah'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(
          child: PrayerButtons(),
        ),
      ),
    );
  }
}

