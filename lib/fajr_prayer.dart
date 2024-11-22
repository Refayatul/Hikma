import 'package:flutter/material.dart';
import 'package:salah/button_details.dart';
import 'package:salah/two_rakahs_of_sunnah.dart';

class FajrPrayerFard extends StatelessWidget {
  const FajrPrayerFard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fajr Prayer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(
              context,
              "Sunnah 2 Rak'ahs",
              const TwoRakahsOfSunnah(),
              Icons.access_alarm,
            ),
            const SizedBox(height: 20),
            buildButton(
              context,
              "Sunnah 2 Rak'ahs",
              const TwoRakahsOfSunnah(),
              Icons.access_alarm,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Return'),
            ),
          ],
        ),
      ),
    );
  }
}
