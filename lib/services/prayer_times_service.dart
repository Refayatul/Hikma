import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class PrayerTimesService {
  static const String calculationMethodKey = 'calculation_method';
  static const String madhabKey = 'madhab';
  static const String highLatitudeRuleKey = 'high_latitude_rule';
  static const String timezoneKey = 'timezone';

  Future<void> initialize() async {
    tz.initializeTimeZones();
  }

  Future<PrayerTimes> getPrayerTimes() async {
    final position = await _getCurrentLocation();
    final coordinates = Coordinates(position.latitude, position.longitude);
    final params = await _getCalculationParameters();

    // Get local timezone based on coordinates
    final timezone = await _getTimezone(position);
    final dateTime = tz.TZDateTime.now(timezone);
    final dateComponents =
        DateComponents(dateTime.year, dateTime.month, dateTime.day);

    return PrayerTimes(coordinates, dateComponents, params);
  }

  Future<tz.Location> _getTimezone(Position position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTimezone = prefs.getString(timezoneKey);

      if (savedTimezone != null) {
        return tz.getLocation(savedTimezone);
      }

      // Default to UTC if no timezone found
      return tz.UTC;
    } catch (e) {
      return tz.UTC;
    }
  }

  Future<CalculationParameters> _getCalculationParameters() async {
    final prefs = await SharedPreferences.getInstance();
    final methodName =
        prefs.getString(calculationMethodKey) ?? 'muslim_world_league';
    final madhabName = prefs.getString(madhabKey) ?? 'shafi';
    final highLatRuleName =
        prefs.getString(highLatitudeRuleKey) ?? 'middle_of_the_night';

    final method = _getCalculationMethod(methodName);
    final params = method.getParameters();
    params.madhab = _getMadhab(madhabName);
    params.highLatitudeRule = _getHighLatitudeRule(highLatRuleName);

    return params;
  }

  CalculationMethod _getCalculationMethod(String name) {
    switch (name) {
      case 'muslim_world_league':
        return CalculationMethod.muslim_world_league;
      case 'islamic_society_na':
        return CalculationMethod.north_america;
      case 'egyptian':
        return CalculationMethod.egyptian;
      case 'umm_al_qura':
        return CalculationMethod.umm_al_qura;
      case 'dubai':
        return CalculationMethod.dubai;
      case 'moon_sighting_committee':
        return CalculationMethod.moon_sighting_committee;
      case 'karachi':
        return CalculationMethod.karachi;
      case 'kuwait':
        return CalculationMethod.kuwait;
      case 'qatar':
        return CalculationMethod.qatar;
      case 'singapore':
        return CalculationMethod.singapore;
      default:
        return CalculationMethod.muslim_world_league;
    }
  }

  Madhab _getMadhab(String name) {
    switch (name) {
      case 'shafi':
        return Madhab.shafi;
      case 'hanafi':
        return Madhab.hanafi;
      default:
        return Madhab.shafi;
    }
  }

  HighLatitudeRule _getHighLatitudeRule(String name) {
    switch (name) {
      case 'middle_of_the_night':
        return HighLatitudeRule.middle_of_the_night;
      case 'seventh_of_the_night':
        return HighLatitudeRule.seventh_of_the_night;
      case 'twilight_angle':
        return HighLatitudeRule.twilight_angle;
      default:
        return HighLatitudeRule.middle_of_the_night;
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<double> getQiblaDirection() async {
    final position = await _getCurrentLocation();
    final coordinates = Coordinates(position.latitude, position.longitude);
    return Qibla(coordinates).direction;
  }

  Future<void> saveCalculationMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(calculationMethodKey, method);
  }

  Future<void> saveMadhab(String madhab) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(madhabKey, madhab);
  }

  Future<void> saveHighLatitudeRule(String rule) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(highLatitudeRuleKey, rule);
  }

  Future<void> saveTimezone(String timezone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(timezoneKey, timezone);
  }

  Future<Map<String, String>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final timezone = await _getCurrentTimezone();

    return {
      'calculation_method':
          prefs.getString(calculationMethodKey) ?? 'muslim_world_league',
      'madhab': prefs.getString(madhabKey) ?? 'shafi',
      'high_latitude_rule':
          prefs.getString(highLatitudeRuleKey) ?? 'middle_of_the_night',
      'timezone': timezone,
    };
  }

  Future<String> _getCurrentTimezone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(timezoneKey) ?? 'UTC';
  }

  String formatPrayerTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Prayer getNextPrayer(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    if (now.isBefore(prayerTimes.fajr)) return Prayer.fajr;
    if (now.isBefore(prayerTimes.sunrise)) return Prayer.sunrise;
    if (now.isBefore(prayerTimes.dhuhr)) return Prayer.dhuhr;
    if (now.isBefore(prayerTimes.asr)) return Prayer.asr;
    if (now.isBefore(prayerTimes.maghrib)) return Prayer.maghrib;
    if (now.isBefore(prayerTimes.isha)) return Prayer.isha;
    return Prayer.none;
  }

  DateTime getNextPrayerTime(PrayerTimes prayerTimes) {
    final nextPrayer = getNextPrayer(prayerTimes);
    switch (nextPrayer) {
      case Prayer.fajr:
        return prayerTimes.fajr;
      case Prayer.sunrise:
        return prayerTimes.sunrise;
      case Prayer.dhuhr:
        return prayerTimes.dhuhr;
      case Prayer.asr:
        return prayerTimes.asr;
      case Prayer.maghrib:
        return prayerTimes.maghrib;
      case Prayer.isha:
        return prayerTimes.isha;
      case Prayer.none:
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final dateComponents =
            DateComponents(tomorrow.year, tomorrow.month, tomorrow.day);
        return PrayerTimes(
          Coordinates(
            prayerTimes.coordinates.latitude,
            prayerTimes.coordinates.longitude,
          ),
          dateComponents,
          prayerTimes.calculationParameters,
        ).fajr;
    }
  }
}

enum Prayer {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
  none,
}
