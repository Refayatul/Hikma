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
            const Text("Learn to Pray Four Rak'as of Sunnah"),
            const SizedBox(height: 20),
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
                    'Make the intention to perform 4 Rak\'ahs of Sunnah prayer for Asr. Say to yourself: "I intend to perform 4 Rak\'ahs of Sunnah prayer for Asr for the sake of Allah."',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '2. First Two Rak\'ahs:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '- Start with Takbiratul Ihram (Allahu Akbar)\n'
                    '- Recite Al-Fatihah\n'
                    '- Recite another Surah\n'
                    '- Perform Ruku and say "Subhana Rabbiyal Azeem" three times\n'
                    '- Stand up saying "Sami Allahu liman hamidah, Rabbana lakal hamd"\n'
                    '- Perform two Sajdahs saying "Subhana Rabbiyal Ala" three times in each\n'
                    '- For second Rak\'ah, repeat all steps except Takbiratul Ihram\n'
                    '- Sit for Tashahhud after second Rak\'ah',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '3. Last Two Rak\'ahs:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '- Stand up for third Rak\'ah\n'
                    '- Recite Al-Fatihah only\n'
                    '- Complete the Rak\'ah as before\n'
                    '- Fourth Rak\'ah same as third\n'
                    '- Sit for final Tashahhud',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '4. Final Tashahhud and Salaam:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '- Recite At-Tahiyyat\n'
                    '- Recite Durood Ibrahim\n'
                    '- Make any dua\n'
                    '- Conclude with Salaam to both sides',
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
