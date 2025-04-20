import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihCounterScreen extends StatefulWidget {
  const TasbihCounterScreen({super.key});

  @override
  State<TasbihCounterScreen> createState() => _TasbihCounterScreenState();
}

class _TasbihCounterScreenState extends State<TasbihCounterScreen> {
  int _count = 0;
  int _target = 33; // Default target
  String _selectedDhikr = 'SubhanAllah';
  final Map<String, int> _dhikrStats = {};
  bool _vibrationEnabled = true;

  final List<String> _dhikrList = [
    'SubhanAllah',
    'Alhamdulillah',
    'Allahu Akbar',
    'La ilaha illallah',
    'Astaghfirullah',
  ];

  final Map<int, String> _presetTargets = {
    33: 'Tasbih (33)',
    99: 'Names of Allah (99)',
    100: 'Century (100)',
    500: 'Extended (500)',
    1000: 'Marathon (1000)',
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt('tasbih_count') ?? 0;
      _target = prefs.getInt('tasbih_target') ?? 33;
      _selectedDhikr = prefs.getString('selected_dhikr') ?? 'SubhanAllah';
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;

      for (final dhikr in _dhikrList) {
        _dhikrStats[dhikr] = prefs.getInt('dhikr_count_$dhikr') ?? 0;
      }
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_count', _count);
    await prefs.setInt('tasbih_target', _target);
    await prefs.setString('selected_dhikr', _selectedDhikr);
    await prefs.setBool('vibration_enabled', _vibrationEnabled);

    for (final entry in _dhikrStats.entries) {
      await prefs.setInt('dhikr_count_${entry.key}', entry.value);
    }
  }

  void _increment() {
    setState(() {
      _count++;
      _dhikrStats[_selectedDhikr] = (_dhikrStats[_selectedDhikr] ?? 0) + 1;
    });

    if (_vibrationEnabled) {
      HapticFeedback.lightImpact();
    }

    if (_count >= _target) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Target reached: $_target ${_selectedDhikr}!'),
          action: SnackBarAction(
            label: 'Reset',
            onPressed: _reset,
          ),
        ),
      );
    }

    _savePreferences();
  }

  void _reset() {
    setState(() => _count = 0);
    _savePreferences();
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Tasbih'),
        actions: [
          IconButton(
            icon: Icon(_vibrationEnabled ? Icons.vibration : Icons.block),
            onPressed: () {
              setState(() => _vibrationEnabled = !_vibrationEnabled);
              _savePreferences();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: _selectedDhikr,
                      isExpanded: true,
                      items: _dhikrList.map((String dhikr) {
                        return DropdownMenuItem<String>(
                          value: dhikr,
                          child: Text(dhikr),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedDhikr = newValue;
                            _count = 0; // Reset count when changing dhikr
                          });
                          _savePreferences();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<int>(
                      value: _target,
                      isExpanded: true,
                      items: _presetTargets.entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() => _target = newValue);
                          _savePreferences();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _increment,
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _count.toString(),
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 96,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        '$_selectedDhikr ($_count/$_target)',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Statistics'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _dhikrStats.entries.map((entry) {
                            return ListTile(
                              title: Text(entry.key),
                              trailing: Text(
                                entry.value.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Statistics'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
