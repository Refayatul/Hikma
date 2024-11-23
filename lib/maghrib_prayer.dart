import 'package:flutter/material.dart';
import 'package:salah/button_details.dart';
import 'package:salah/three_rakas_of_fard.dart';
import 'package:salah/two_rakahs_of_sunnah.dart';

class MaghribPrayerFard extends StatelessWidget {
  const MaghribPrayerFard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maghrib Prayer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(context, "3 Rak'as of Fard", ThreeRakasOfFard(),
                  Icons.add_task_sharp),
              const SizedBox(
                height: 12,
              ),
              buildButton(context, "2 Rak'as of Sunnah", TwoRakahsOfSunnah(),
                  Icons.airline_stops_sharp),
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
