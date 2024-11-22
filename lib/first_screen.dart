import 'package:flutter/material.dart';
import 'fajr_prayer.dart';
import 'dhuhr_prayer.dart';
import 'asr_prayer.dart';
import 'maghrib_prayer.dart';
import 'isha_prayer.dart';
import 'button_details.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Learn Salah')),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            buildButton(
              context,
              'Fajr',
              const FajrPrayerFard(),
              Icons.wb_sunny,
            ),
            const SizedBox(height: 12),
            buildButton(
              context,
              'Dhuhr',
              const DhuhrPrayerFard(),
              Icons.access_time,
            ),
            const SizedBox(height: 12),
            buildButton(
              context,
              'Asr',
              const AsrPrayerFard(),
              Icons.access_alarm,
            ),
            const SizedBox(height: 12),
            buildButton(
              context,
              'Maghrib',
              const MaghribPrayerFard(),
              Icons.nights_stay,
            ),
            const SizedBox(height: 12),
            buildButton(
              context,
              'Isha',
              const IshaPrayerFard(),
              Icons.bedtime,
            ),
          ],
        ),
      ),
    );
  }
}
