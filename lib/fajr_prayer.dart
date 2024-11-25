import 'package:flutter/material.dart';
import 'package:salah/button_details.dart';
import 'package:salah/two_rakahs_of_sunnah.dart';
import 'package:salah/two_rakahs_of_fard.dart';

class FajrPrayerFard extends StatelessWidget {
  const FajrPrayerFard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Fajr Prayer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(
                context,
                "Sunnah 2 Rak'ahs",
                const TwoRakahsOfSunnah(),
                Icons.access_alarm,
              ),
              const SizedBox(height: 12),
              buildButton(
                context,
                "Fard 2 Rak'ahs",
                const TwoRakasOfFard(),
                Icons.access_alarm,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Return'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
