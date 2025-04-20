import 'package:flutter/material.dart';
import '../services/prayer_times_service.dart';
import '../services/quran_service.dart';
import 'package:adhan/adhan.dart';
import 'tasbih_counter_screen.dart';
import 'ramadan_tracker_screen.dart';
import 'quiz_screen.dart';
import 'prayer_journal_screen.dart';
import 'dua_screen.dart';
import 'ai_qa_screen.dart';
import 'quran/surah_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PrayerTimesService _prayerService = PrayerTimesService();
  final QuranService _quranService = QuranService();
  PrayerTimes? _prayerTimes;
  double? _qiblaDirection;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    _loadQiblaDirection();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final times = await _prayerService.getPrayerTimes();
      setState(() => _prayerTimes = times);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadQiblaDirection() async {
    try {
      final direction = await _prayerService.getQiblaDirection();
      setState(() => _qiblaDirection = direction);
    } catch (e) {
      // Handle error
    }
  }

  Widget _buildPrayerTimesTab() {
    if (_prayerTimes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPrayerTimeCard('Fajr', _prayerTimes!.fajr, context),
        _buildPrayerTimeCard('Sunrise', _prayerTimes!.sunrise, context),
        _buildPrayerTimeCard('Dhuhr', _prayerTimes!.dhuhr, context),
        _buildPrayerTimeCard('Asr', _prayerTimes!.asr, context),
        _buildPrayerTimeCard('Maghrib', _prayerTimes!.maghrib, context),
        _buildPrayerTimeCard('Isha', _prayerTimes!.isha, context),
        _buildNextPrayerTime(context),
      ],
    );
  }

  Widget _buildPrayerTimeCard(
      String name, DateTime time, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text(TimeOfDay.fromDateTime(time).format(context)),
        trailing: Icon(
          time.isBefore(DateTime.now()) ? Icons.done : Icons.access_time,
        ),
      ),
    );
  }

  Widget _buildNextPrayerTime(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime? nextPrayerTime;
    String nextPrayerName = '';

    if (_prayerTimes!.fajr.isAfter(now)) {
      nextPrayerTime = _prayerTimes!.fajr;
      nextPrayerName = 'Fajr';
    } else if (_prayerTimes!.sunrise.isAfter(now)) {
      nextPrayerTime = _prayerTimes!.sunrise;
      nextPrayerName = 'Sunrise';
    } else if (_prayerTimes!.dhuhr.isAfter(now)) {
      nextPrayerTime = _prayerTimes!.dhuhr;
      nextPrayerName = 'Dhuhr';
    } else if (_prayerTimes!.asr.isAfter(now)) {
      nextPrayerTime = _prayerTimes!.asr;
      nextPrayerName = 'Asr';
    } else if (_prayerTimes!.maghrib.isAfter(now)) {
      nextPrayerTime = _prayerTimes!.maghrib;
      nextPrayerName = 'Maghrib';
    } else if (_prayerTimes!.isha.isAfter(now)) {
      nextPrayerTime = _prayerTimes!.isha;
      nextPrayerName = 'Isha';
    } else {
      // If all prayers have passed, set next prayer to Fajr of the next day
      nextPrayerTime = _prayerTimes!.fajr.add(const Duration(days: 1));
      nextPrayerName = 'Fajr';
    }

    Duration timeUntilPrayer = nextPrayerTime.difference(now);
    String formattedDuration =
        '${timeUntilPrayer.inHours}h ${timeUntilPrayer.inMinutes % 60}m';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: const Text('Next Prayer:'),
        subtitle: Text('$nextPrayerName in $formattedDuration'),
        trailing: const Icon(Icons.timer),
      ),
    );
  }

  Widget _buildQuranTab() {
    return ListView(
      children: [
        ListTile(
          title: const Text('Continue Reading'),
          subtitle: const Text('Last read: Al-Fatiha'),
          leading: const Icon(Icons.book),
          onTap: () {
            // Navigate to last read position
          },
        ),
        ListTile(
          title: const Text('Browse Surahs'),
          leading: const Icon(Icons.list),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SurahListScreen(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Search Quran'),
          leading: const Icon(Icons.search),
          onTap: () {
            // Show search dialog
          },
        ),
        ListTile(
          title: const Text('Bookmarks'),
          leading: const Icon(Icons.bookmark),
          onTap: () {
            // Navigate to bookmarks
          },
        ),
      ],
    );
  }

  Widget _buildQiblaTab() {
    return _qiblaDirection == null
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Qibla Direction',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Transform.rotate(
                  angle: _qiblaDirection!,
                  child: const Icon(
                    Icons.navigation,
                    size: 100,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${(_qiblaDirection! * (180 / 3.14159)).toStringAsFixed(1)}°',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
  }

  Widget _buildTeachingsTab() {
    return ListView(
      children: [
        _buildTeachingCard(
          'Daily Islamic Quiz',
          'Test your knowledge with daily questions',
          Icons.quiz,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuizScreen(),
            ),
          ),
        ),
        _buildTeachingCard(
          'Prayer Journal',
          'Track your prayers and spiritual journey',
          Icons.book_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrayerJournalScreen(),
            ),
          ),
        ),
        _buildTeachingCard(
          'Smart Dua & Dhikr',
          'Daily remembrance with travel detection',
          Icons.favorite_outline,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DuaScreen(),
            ),
          ),
        ),
        _buildTeachingCard(
          'Ramadan Tracker',
          'Track fasting days, iftar times, and charity goals',
          Icons.calendar_month,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RamadanTrackerScreen(),
            ),
          ),
        ),
        _buildTeachingCard(
          'Digital Tasbih',
          'Keep track of your dhikr with digital counter',
          Icons.touch_app,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TasbihCounterScreen(),
            ),
          ),
        ),
        _buildTeachingCard(
          'Prayer Guide',
          'Learn how to pray correctly',
          Icons.school,
        ),
        _buildTeachingCard(
          'Daily Dhikr',
          'Remember Allah throughout the day',
          Icons.favorite,
        ),
        _buildTeachingCard(
          'Hadith Collection',
          'Learn from the Prophet\'s teachings',
          Icons.history_edu,
        ),
        _buildTeachingCard(
          'Islamic Articles',
          'Read about various Islamic topics',
          Icons.article,
        ),
      ],
    );
  }

  Widget _buildTeachingCard(String title, String subtitle, IconData icon,
      {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icon),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap ??
            () {
              // Default navigation logic
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildPrayerTimesTab(),
          _buildQuranTab(),
          _buildQiblaTab(),
          _buildTeachingsTab(),
          const AIQAScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Prayer Times',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Qibla',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Ask AI',
          ),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
