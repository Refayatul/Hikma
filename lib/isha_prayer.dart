import 'package:flutter/material.dart';
import 'package:salah/button_details.dart';
import 'package:salah/four_rakahs_of_fard.dart';
import 'package:salah/three_rakas_of_witr.dart';
import 'package:salah/two_rakahs_of_sunnah.dart';

class IshaPrayerFard extends StatelessWidget {
  const IshaPrayerFard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Isha Prayer')),
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
                "Fard 4 Rak'ahs",
                const FourRakahsOfFard(),
                Icons.access_alarm,
              ),
              const SizedBox(height: 12),
              buildButton(
                context,
                "Witr 3 Rak'ahs",
                const ThreeRakasOfWitr(),
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
