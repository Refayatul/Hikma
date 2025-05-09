import 'package:flutter/material.dart';
import 'fajr_prayer_screen.dart'; // Updated import
import 'dhuhr_prayer_screen.dart';
import 'asr_prayer.dart';
import 'maghrib_prayer.dart';
import 'isha_prayer.dart';
import 'button_details.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(centerTitle: true, title: const Text('Learn Salah')),*/
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(
                context,
                'Fajr',
                const FajrPrayerScreen(), // Updated screen
                Icons.wb_sunny,
              ),
              const SizedBox(height: 12),
              buildButton(
                context,
                'Dhuhr',
                const DhuhrPrayerScreen(),
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
      ),
    );
  }
}
