import 'package:flutter/material.dart';
import 'package:salah/button_details.dart';
import 'package:salah/four_rakahs_of_fard.dart';
import 'package:salah/four_rakahs_of_sunnah.dart';

class AsrPrayerFard extends StatelessWidget {
  const AsrPrayerFard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asr Prayer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(context, "Sunnah 4 Rak'as", FourRakahsOfSunnah(),
                  Icons.account_tree),
              const SizedBox(
                height: 12,
              ),
              buildButton(context, "Fard 4 Rak'as", FourRakahsOfFard(),
                  Icons.add_alert),
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
