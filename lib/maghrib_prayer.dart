import 'package:flutter/material.dart';

class MaghribPrayerFard extends StatelessWidget {
  const MaghribPrayerFard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maghrib Prayer')),
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
