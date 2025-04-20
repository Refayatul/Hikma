import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'local_storage_service.dart';

class DuaService {
  final FlutterLocalNotificationsPlugin _notifications;
  static const double _travelDistanceThreshold = 80.0; // 80km = travel distance
  Position? _lastKnownLocation;

  DuaService(this._notifications) {
    _loadLastLocation();
  }

  Future<void> _loadLastLocation() async {
    final lastLocation = LocalStorageService.duasBox.get('last_known_location');
    if (lastLocation != null) {
      final locationMap = json.decode(lastLocation);
      _lastKnownLocation = Position(
        longitude: locationMap['longitude'],
        latitude: locationMap['latitude'],
        timestamp: DateTime.parse(locationMap['timestamp']),
        accuracy: locationMap['accuracy'],
        altitude: locationMap['altitude'],
        heading: locationMap['heading'],
        speed: locationMap['speed'],
        speedAccuracy: locationMap['speedAccuracy'],
        altitudeAccuracy: 0, // Added as required
        headingAccuracy: 0, // Added as required
      );
    }
  }

  Future<void> _saveLastLocation(Position position) async {
    await LocalStorageService.duasBox.put(
      'last_known_location',
      json.encode({
        'longitude': position.longitude,
        'latitude': position.latitude,
        'timestamp': position.timestamp.toIso8601String(),
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'heading': position.heading,
        'speed': position.speed,
        'speedAccuracy': position.speedAccuracy,
        'altitudeAccuracy': position.altitudeAccuracy,
        'headingAccuracy': position.headingAccuracy,
      }),
    );
    _lastKnownLocation = position;
  }

  Future<bool> checkIfTraveling() async {
    try {
      final currentPosition = await Geolocator.getCurrentPosition();

      if (_lastKnownLocation != null) {
        final distance = Geolocator.distanceBetween(
          _lastKnownLocation!.latitude,
          _lastKnownLocation!.longitude,
          currentPosition.latitude,
          currentPosition.longitude,
        );

        // If distance is more than threshold, user is traveling
        if (distance > _travelDistanceThreshold * 1000) {
          // Convert to meters
          await _showTravelDuaNotification();
          return true;
        }
      }

      await _saveLastLocation(currentPosition);
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _showTravelDuaNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'dua_channel',
      'Travel Duas',
      channelDescription: 'Notifications for travel duas',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      'Travel Dua Reminder',
      'Don\'t forget to recite the travel dua',
      details,
    );
  }

  Future<List<Map<String, dynamic>>> getDuas(String category) async {
    // Get duas from Hive box
    final duas = LocalStorageService.getAllDuas()
        .where(
          (dua) => dua['category'] == category,
        )
        .toList();

    // If no duas exist for this category, initialize with defaults
    if (duas.isEmpty && defaultDuas.containsKey(category)) {
      final defaultCategoryDuas = defaultDuas[category]!;
      for (final dua in defaultCategoryDuas) {
        final duaWithCategory = {...dua, 'category': category};
        await LocalStorageService.saveDua(
          '${category}_${duas.length}',
          duaWithCategory,
        );
      }
      return defaultCategoryDuas;
    }

    return duas;
  }

  Future<void> saveDua(String category, Map<String, dynamic> dua) async {
    final duas = await getDuas(category);
    final duaWithCategory = {...dua, 'category': category};
    await LocalStorageService.saveDua(
      '${category}_${duas.length}',
      duaWithCategory,
    );
  }

  Future<void> updateDuaProgress(String category, int index, int count) async {
    final dua = await LocalStorageService.getDua('${category}_$index');
    if (dua != null) {
      dua['count'] = count;
      await LocalStorageService.saveDua('${category}_$index', dua);
    }
  }

  static const Map<String, List<Map<String, dynamic>>> defaultDuas = {
    'travel': [
      {
        'arabic':
            'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ',
        'transliteration':
            'Subhaanal-lathee sakhkhara lanaa haatha wamaa kunnaa lahu muqrineen',
        'translation':
            'Glory to Him Who has subjected this to us, and we could never have accomplished it',
        'count': 0,
        'target': 1,
      },
      // Add more travel duas
    ],
    'morning': [
      {
        'arabic': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
        'transliteration': 'Asbahnaa wa-asbahal-mulku lillah',
        'translation':
            'We have reached the morning and kingship belongs to Allah',
        'count': 0,
        'target': 1,
      },
      // Add more morning duas
    ],
    // Add more categories
  };
}
