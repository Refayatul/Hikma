import 'package:flutter/material.dart';
import 'package:salah/button_details.dart';

class PrayerButtons extends StatelessWidget {
  const PrayerButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        buildPrayerButton('Fajr', Icons.wb_sunny, () {
          // Add your button action here
        }),
        const SizedBox(height: 16.0),
        buildPrayerButton('Dhuhr', Icons.access_time, () {
          // Add your button action here
        }),
        const SizedBox(height: 16.0),
        buildPrayerButton('Asr', Icons.access_alarm, () {
          // Add your button action here
        }),
        const SizedBox(height: 16.0),
        buildPrayerButton('Maghrib', Icons.nights_stay, () {
          // Add your button action here
        }),
        const SizedBox(height: 16.0),
        buildPrayerButton('Isha', Icons.bedtime, () {
          // Add your button action here
        }),
      ],
    );
  }
}