import 'package:flutter/material.dart';

class FourRakahsOfSunnah extends StatelessWidget {
  const FourRakahsOfSunnah({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("4 Rak'as of Sunnah"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Learn to Pray 4 Rak'as of Sunnah"),
            const SizedBox(height: 20), // Add some spacing
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Steps for Performing 4 Rak\'ahs of Sunnah Prayer:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '1. Niyyah (Intention):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Make the intention to perform 4 Rak\'ahs of Sunnah prayer. Say to yourself: "I intend to perform 4 Rak\'ahs of Sunnah prayer for the sake of Allah."',
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
                    '8. Third Rak\'ah:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Repeat steps 3-6 for the third Rak\'ah.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '9. Fourth Rak\'ah:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Repeat steps 3-6 for the fourth Rak\'ah.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '10. Tasleem (Ending the Prayer):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'End the prayer by saying "As-salamu alaykum wa rahmatullah" (Peace be upon you and the mercy of Allah).',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Return'),
            ),
          ],
        ),
      ),
    );
  }
}
