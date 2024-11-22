import 'package:flutter/material.dart';

class FajrPrayerFard extends StatelessWidget {
  const FajrPrayerFard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fajr Prayer')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Return'),
        ),
      ),
    );
  }
} 

