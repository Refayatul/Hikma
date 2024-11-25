import 'package:flutter/material.dart';

class TwoRakahsOfSunnah extends StatelessWidget {
  const TwoRakahsOfSunnah({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("2 Rak'as of Sunnah"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Learn to Pray 2 Rak'ahs of Sunnah"),
            const SizedBox(height: 20), 
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Steps for Performing 2 Rak\'ahs of Sunnah Prayer:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '1. Niyyah (Intention):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Make the intention to perform 2 Rak\'ahs of Sunnah prayer. Say to yourself: "I intend to perform 2 Rak\'ahs of Sunnah prayer for the sake of Allah."',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Arabic Pronunciation: "Nawaytu an usalli rak\'ataini sunnatan lillahi ta\'ala."',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '2. Takbiratul Ihram (Starting with Takbir):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Stand up straight and say "Allahu Akbar" (Allah is the greatest).',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Arabic Pronunciation: "Allahu akbar."',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '3. Recitation of Al-Fatihah (The Opening Chapter):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Recite the Al-Fatihah chapter from the Quran.',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Arabic Pronunciation: "Alhamdu lillahi rabbil \'alamin. Arrahmanir rahim. Maliki yawmid din. Iyyaka na\'budu wa iyyaka nasta\'in. Ihdinas siratal mustaqim. Siratal ladhina an\'amta \'alayhim ghayril maghdubi \'alayhim wa lad dhalin."',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '4. Recitation of Another Chapter (Optional):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Recite another chapter from the Quran, if desired.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '5. Ruku\' (Bowing):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Bow down and place your hands on your knees.',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Arabic Pronunciation: "Allahu akbar."',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '6. Sajdah (Prostration):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Prostrate and place your forehead on the ground.',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Arabic Pronunciation: "Allahu akbar."',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '7. Second Rak\'ah:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Repeat steps 3-6 for the second Rak\'ah.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '8. Tasleem (Ending the Prayer):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'End the prayer by saying "As-salamu alaykum wa rahmatullah"',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
    );
  }
}
