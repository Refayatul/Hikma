import 'package:flutter/material.dart';
import 'package:salah/button_details.dart';
import 'package:salah/four_rakahs_of_fard.dart';
import 'package:salah/two_rakahs_of_sunnah.dart';

class DhuhrPrayerFard extends StatelessWidget {
  const DhuhrPrayerFard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Dhuhr Prayer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(
                context,
                "Sunnah 2 Rak'ahs x2",
                const TwoRakahsOfSunnah(),
                Icons.access_alarm,
              ),
              const SizedBox(height: 12),
              buildButton(
                context,
                "Fard 4 Rak'as",
                FourRakahsOfFard(),
                Icons.access_time_sharp,
              ),
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
