import 'package:flutter/material.dart';

class PrayerGuideScreen extends StatelessWidget {
  const PrayerGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Guide'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPrayerStep(
            1,
            'Intention (Niyyah)',
            'Make the intention for prayer in your heart',
            'assets/images/prayer/niyyah.png',
          ),
          _buildPrayerStep(
            2,
            'Takbeer (Allahu Akbar)',
            'Raise your hands to your ears and say "Allahu Akbar"',
            'assets/images/prayer/takbeer.png',
          ),
          _buildPrayerStep(
            3,
            'Standing Position (Qiyam)',
            'Place your right hand over your left hand below the navel',
            'assets/images/prayer/qiyam.png',
          ),
          _buildPrayerStep(
            4,
            'Surah Al-Fatiha',
            'Recite Surah Al-Fatiha followed by any other surah',
            'assets/images/prayer/recitation.png',
          ),
          _buildPrayerStep(
            5,
            'Ruku',
            'Bow down with your back straight and hands on knees',
            'assets/images/prayer/ruku.png',
          ),
          _buildPrayerStep(
            6,
            'Sujood',
            'Prostrate with forehead, nose, palms, knees and toes touching the ground',
            'assets/images/prayer/sujood.png',
          ),
          _buildPrayerStep(
            7,
            'Sitting Position (Tashahhud)',
            'Sit on your left foot with right foot upright',
            'assets/images/prayer/tashahhud.png',
          ),
          _buildPrayerStep(
            8,
            'Final Salam',
            'Turn your head to the right and left saying "Assalamu alaikum wa rahmatullah"',
            'assets/images/prayer/salam.png',
          ),
          const SizedBox(height: 20),
          _buildImportantNotes(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Launch interactive prayer tutorial
        },
        label: const Text('Start Tutorial'),
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildPrayerStep(
    int stepNumber,
    String title,
    String description,
    String imagePath,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          child: Text(stepNumber.toString()),
        ),
        title: Text(title),
        subtitle: Text(description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildAudioPlayer(stepNumber),
                const SizedBox(height: 16),
                const Text(
                  'Common Mistakes to Avoid:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildMistakesList(stepNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(int stepNumber) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {
            // Play audio guidance for this step
          },
        ),
        Expanded(
          child: Slider(
            value: 0,
            onChanged: (value) {
              // Handle audio seeking
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMistakesList(int stepNumber) {
    final mistakes = _getCommonMistakes(stepNumber);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mistakes.map((mistake) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(child: Text(mistake)),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<String> _getCommonMistakes(int stepNumber) {
    switch (stepNumber) {
      case 1:
        return [
          'Making verbal intention',
          'Delaying the prayer after intention',
        ];
      case 2:
        return [
          'Not raising hands to ears',
          'Moving lips during takbeer without voice',
        ];
      case 3:
        return [
          'Looking down instead of sujood position',
          'Not maintaining a straight back',
        ];
      case 4:
        return [
          'Rushing through recitation',
          'Incorrect pronunciation',
        ];
      case 5:
        return [
          'Bowing too low or too high',
          'Not keeping back straight',
        ];
      case 6:
        return [
          'Not putting weight on forehead and nose',
          'Elbows touching the ground',
        ];
      case 7:
        return [
          'Incorrect foot position',
          'Moving finger without understanding',
        ];
      case 8:
        return [
          'Turning head too far',
          'Not completing the prayer with salam',
        ];
      default:
        return [];
    }
  }

  Widget _buildImportantNotes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Important Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildNote(
              'Concentration',
              'Maintain focus and avoid distractions during prayer',
            ),
            _buildNote(
              'Cleanliness',
              'Ensure body, clothes and prayer area are clean',
            ),
            _buildNote(
              'Timing',
              'Pray at the correct times and avoid delays',
            ),
            _buildNote(
              'Direction',
              'Face the Qibla (direction of Kaaba)',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNote(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
