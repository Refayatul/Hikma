import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hijri/hijri_calendar.dart';
import '../services/prayer_times_service.dart';

class RamadanTrackerScreen extends StatefulWidget {
  const RamadanTrackerScreen({super.key});

  @override
  State<RamadanTrackerScreen> createState() => _RamadanTrackerScreenState();
}

class _RamadanTrackerScreenState extends State<RamadanTrackerScreen> {
  final PrayerTimesService _prayerService = PrayerTimesService();
  DateTime? _fajrTime;
  DateTime? _maghribTime;
  double _charityGoal = 0;
  double _charityDonated = 0;
  Map<int, bool> _fastingDays = {};
  bool _isRamadan = false;
  late HijriCalendar _today;
  String _nextMeal = '';
  Duration _timeUntilNextMeal = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    _today = HijriCalendar.now();
    _isRamadan = _today.hMonth == 9; // 9 is Ramadan

    setState(() {
      _charityGoal = prefs.getDouble('ramadan_charity_goal') ?? 0;
      _charityDonated = prefs.getDouble('ramadan_charity_donated') ?? 0;

      // Load fasting days
      for (int i = 1; i <= 30; i++) {
        _fastingDays[i] = prefs.getBool('ramadan_fasting_day_$i') ?? false;
      }
    });

    await _loadPrayerTimes();
    _updateNextMeal();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final prayerTimes = await _prayerService.getPrayerTimes();
      setState(() {
        _fajrTime = prayerTimes.fajr;
        _maghribTime = prayerTimes.maghrib;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _updateNextMeal() {
    if (_fajrTime == null || _maghribTime == null) return;

    final now = DateTime.now();
    if (now.isBefore(_fajrTime!)) {
      _nextMeal = 'Suhoor';
      _timeUntilNextMeal = _fajrTime!.difference(now);
    } else if (now.isBefore(_maghribTime!)) {
      _nextMeal = 'Iftar';
      _timeUntilNextMeal = _maghribTime!.difference(now);
    } else {
      _nextMeal = 'Suhoor';
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final nextFajr = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        _fajrTime!.hour,
        _fajrTime!.minute,
      );
      _timeUntilNextMeal = nextFajr.difference(now);
    }

    // Update timer every minute
    Future.delayed(const Duration(minutes: 1), _updateNextMeal);
    setState(() {});
  }

  Future<void> _updateCharityGoal(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('ramadan_charity_goal', amount);
    setState(() => _charityGoal = amount);
  }

  Future<void> _addCharityDonation(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final total = _charityDonated + amount;
    await prefs.setDouble('ramadan_charity_donated', total);
    setState(() => _charityDonated = total);
  }

  Future<void> _toggleFastingDay(int day) async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !(_fastingDays[day] ?? false);
    await prefs.setBool('ramadan_fasting_day_$day', newValue);
    setState(() => _fastingDays[day] = newValue);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ramadan ${_today.hYear}'),
      ),
      body: _isRamadan ? _buildRamadanContent() : _buildOffSeasonContent(),
    );
  }

  Widget _buildRamadanContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _nextMeal,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Time until $_nextMeal: ${_formatDuration(_timeUntilNextMeal)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Charity Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _charityGoal > 0 ? _charityDonated / _charityGoal : 0,
                ),
                const SizedBox(height: 8),
                Text(
                  'Donated: \$${_charityDonated.toStringAsFixed(2)} / \$${_charityGoal.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showCharityGoalDialog(),
                      child: const Text('Set Goal'),
                    ),
                    ElevatedButton(
                      onPressed: () => _showDonationDialog(),
                      child: const Text('Add Donation'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fasting Calendar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    final day = index + 1;
                    final completed = _fastingDays[day] ?? false;
                    return InkWell(
                      onTap: () => _toggleFastingDay(day),
                      child: Container(
                        decoration: BoxDecoration(
                          color: completed ? Colors.green : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              color: completed ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOffSeasonContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'It\'s not Ramadan yet',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Text(
            'Current Islamic Date: ${_today.toFormat("dd MMMM yyyy")}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showCharityGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double amount = _charityGoal;
        return AlertDialog(
          title: const Text('Set Charity Goal'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: '\$',
              hintText: 'Enter goal amount',
            ),
            onChanged: (value) => amount = double.tryParse(value) ?? 0,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                _updateCharityGoal(amount);
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  void _showDonationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double amount = 0;
        return AlertDialog(
          title: const Text('Add Donation'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: '\$',
              hintText: 'Enter donation amount',
            ),
            onChanged: (value) => amount = double.tryParse(value) ?? 0,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                _addCharityDonation(amount);
                Navigator.pop(context);
              },
              child: const Text('ADD'),
            ),
          ],
        );
      },
    );
  }
}
