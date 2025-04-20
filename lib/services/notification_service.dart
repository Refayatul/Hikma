import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'prayer_times_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final PrayerTimesService _prayerService = PrayerTimesService();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // Handle iOS foreground notification
      },
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        // Handle notification tap
      },
    );

    // Request permissions after initialization
    await requestPermissions();
  }

  Future<void> schedulePrayerNotifications() async {
    await _notifications.cancelAll(); // Clear existing notifications
    final prayerTimes = await _prayerService.getPrayerTimes();

    // Schedule Fajr notification
    await _scheduleNotification(
      1,
      'Fajr Prayer Time',
      'It\'s time for Fajr prayer',
      prayerTimes.fajr,
    );

    // Schedule Dhuhr notification
    await _scheduleNotification(
      2,
      'Dhuhr Prayer Time',
      'It\'s time for Dhuhr prayer',
      prayerTimes.dhuhr,
    );

    // Schedule Asr notification
    await _scheduleNotification(
      3,
      'Asr Prayer Time',
      'It\'s time for Asr prayer',
      prayerTimes.asr,
    );

    // Schedule Maghrib notification
    await _scheduleNotification(
      4,
      'Maghrib Prayer Time',
      'It\'s time for Maghrib prayer',
      prayerTimes.maghrib,
    );

    // Schedule Isha notification
    await _scheduleNotification(
      5,
      'Isha Prayer Time',
      'It\'s time for Isha prayer',
      prayerTimes.isha,
    );
  }

  Future<void> scheduleAdhkarNotifications() async {
    final now = DateTime.now();

    // Schedule morning adhkar notification
    final morningTime = DateTime(
      now.year,
      now.month,
      now.day,
      6, // 6 AM
      0,
    );
    await _scheduleRepeatingNotification(
      6,
      'Morning Adhkar',
      'Time for your morning remembrance',
      morningTime,
    );

    // Schedule evening adhkar notification
    final eveningTime = DateTime(
      now.year,
      now.month,
      now.day,
      17, // 5 PM
      0,
    );
    await _scheduleRepeatingNotification(
      7,
      'Evening Adhkar',
      'Time for your evening remembrance',
      eveningTime,
    );
  }

  Future<void> _scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    if (scheduledTime.isBefore(DateTime.now())) {
      // If prayer time has passed, schedule for tomorrow
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_times',
          'Prayer Times',
          channelDescription: 'Notifications for prayer times',
          importance: Importance.high,
          priority: Priority.high,
          enableLights: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('adhan'),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'adhan.aiff',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleRepeatingNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'adhkar',
          'Daily Adhkar',
          channelDescription: 'Notifications for daily remembrance',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<bool> requestPermissions() async {
    // For Android
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidImplementation?.requestNotificationsPermission() ?? false;

    // For iOS
    final iOSImplementation = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final allowed = await iOSImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    ) ?? false;

    return granted || allowed;
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('prayerNotifications') ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('prayerNotifications', enabled);
    
    if (enabled) {
      await schedulePrayerNotifications();
    } else {
      await cancelAllNotifications();
    }
  }
}
