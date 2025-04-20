import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/dua_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:geolocator/geolocator.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> with WidgetsBindingObserver {
  late final DuaService _duaService;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, List<Map<String, dynamic>>> _duasByCategory = {};
  bool _isLoading = true;
  String _selectedCategory = 'morning';
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkTravelStatus();
    }
  }

  Future<void> _initialize() async {
    final notifications = FlutterLocalNotificationsPlugin();
    await notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    _duaService = DuaService(notifications);
    await _loadDuas();
    await _requestLocationPermission();
    await _checkTravelStatus();
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    setState(() {
      _locationPermissionGranted = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    });
  }

  Future<void> _checkTravelStatus() async {
    if (!_locationPermissionGranted) return;

    final isTraveling = await _duaService.checkIfTraveling();
    if (isTraveling && mounted) {
      setState(() => _selectedCategory = 'travel');
    }
  }

  Future<void> _loadDuas() async {
    try {
      for (final category in [
        'morning',
        'evening',
        'travel',
        'food',
        'sleep'
      ]) {
        final duas = await _duaService.getDuas(category);
        if (duas.isEmpty) {
          _duasByCategory[category] = DuaService.defaultDuas[category] ?? [];
          await _duaService.saveDua(category, _duasByCategory[category]![0]);
        } else {
          _duasByCategory[category] = duas;
        }
      }
      setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading duas: $e')),
        );
      }
    }
  }

  Future<void> _incrementCount(String category, int index) async {
    setState(() {
      _duasByCategory[category]![index]['count']++;
    });
    await _duaService.updateDuaProgress(
      category,
      index,
      _duasByCategory[category]![index]['count'],
    );
  }

  Future<void> _playAudio(String audioFile) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/duas/$audioFile'));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Duas'),
        actions: [
          if (!_locationPermissionGranted)
            IconButton(
              icon: const Icon(Icons.location_disabled),
              onPressed: _requestLocationPermission,
              tooltip: 'Enable location for travel duas',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Morning', 'morning'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Evening', 'evening'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Travel', 'travel'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Food', 'food'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Sleep', 'sleep'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _duasByCategory[_selectedCategory]?.length ?? 0,
              itemBuilder: (context, index) {
                final dua = _duasByCategory[_selectedCategory]![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text('${index + 1}'),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () => _playAudio(dua['audio'] ?? ''),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          dua['arabic'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Scheherazade',
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dua['transliteration'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dua['translation'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Count: ${dua['count']}/${dua['target']}',
                              style: TextStyle(
                                color: dua['count'] >= dua['target']
                                    ? Colors.green
                                    : null,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _incrementCount(_selectedCategory, index),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String category) {
    return FilterChip(
      selected: _selectedCategory == category,
      label: Text(label),
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedCategory = category);
        }
      },
    );
  }
}
