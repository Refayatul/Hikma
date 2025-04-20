import 'package:flutter/material.dart';
import '../services/prayer_times_service.dart';
import '../services/notification_service.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PrayerTimesService _prayerService = PrayerTimesService();
  final NotificationService _notificationService = NotificationService();
  Map<String, String> _settings = {};
  bool _notificationsEnabled = true;
  bool _adhkarNotificationsEnabled = true;
  String? _selectedLanguage = 'en';
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _prayerService.getSettings();
    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        _settings = settings;
        _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
        _adhkarNotificationsEnabled =
            prefs.getBool('adhkar_notifications_enabled') ?? true;
        _selectedLanguage = prefs.getString('language') ?? 'en';
        _darkMode = prefs.getBool('dark_mode') ?? false;
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool(
        'adhkar_notifications_enabled', _adhkarNotificationsEnabled);
    await prefs.setString('language', _selectedLanguage!);
    await prefs.setBool('dark_mode', _darkMode);

    if (_notificationsEnabled) {
      await _notificationService.schedulePrayerNotifications();
      if (_adhkarNotificationsEnabled) {
        await _notificationService.scheduleAdhkarNotifications();
      }
    } else {
      await _notificationService.cancelAllNotifications();
    }
  }

  Widget _buildCalculationMethodSettings() {
    return Card(
      child: ExpansionTile(
        title: const Text('Prayer Time Calculation'),
        children: [
          ListTile(
            title: const Text('Calculation Method'),
            subtitle:
                Text(_getMethodName(_settings['calculation_method'] ?? '')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCalculationMethodDialog(),
          ),
          ListTile(
            title: const Text('Madhab'),
            subtitle: Text(_settings['madhab']?.toUpperCase() ?? 'Shafi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showMadhabDialog(),
          ),
          ListTile(
            title: const Text('High Latitude Rule'),
            subtitle: Text(
              _settings['high_latitude_rule']
                      ?.replaceAll('_', ' ')
                      .toUpperCase() ??
                  'Middle of the Night',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showHighLatitudeDialog(),
          ),
        ],
      ),
    );
  }

  String _getMethodName(String method) {
    switch (method) {
      case 'muslim_world_league':
        return 'Muslim World League';
      case 'islamic_society_na':
        return 'Islamic Society of North America';
      case 'egyptian':
        return 'Egyptian General Authority';
      case 'umm_al_qura':
        return 'Umm Al-Qura University';
      case 'dubai':
        return 'Dubai';
      case 'moon_sighting_committee':
        return 'Moonsighting Committee';
      case 'karachi':
        return 'University of Islamic Sciences, Karachi';
      case 'kuwait':
        return 'Kuwait';
      case 'qatar':
        return 'Qatar';
      case 'singapore':
        return 'Singapore';
      default:
        return 'Muslim World League';
    }
  }

  void _showCalculationMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calculation Method'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMethodOption('muslim_world_league', 'Muslim World League'),
              _buildMethodOption('islamic_society_na', 'ISNA'),
              _buildMethodOption('egyptian', 'Egyptian'),
              _buildMethodOption('umm_al_qura', 'Umm Al-Qura'),
              _buildMethodOption('dubai', 'Dubai'),
              _buildMethodOption(
                  'moon_sighting_committee', 'Moonsighting Committee'),
              _buildMethodOption('karachi', 'Karachi'),
              _buildMethodOption('kuwait', 'Kuwait'),
              _buildMethodOption('qatar', 'Qatar'),
              _buildMethodOption('singapore', 'Singapore'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodOption(String value, String title) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: _settings['calculation_method'],
      onChanged: (newValue) async {
        if (newValue != null) {
          await _prayerService.saveCalculationMethod(newValue);
          await _loadSettings();
          if (mounted) {
            Navigator.pop(context);
          }
        }
      },
    );
  }

  void _showMadhabDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Madhab'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Shafi'),
              value: 'shafi',
              groupValue: _settings['madhab'],
              onChanged: (value) async {
                if (value != null) {
                  await _prayerService.saveMadhab(value);
                  await _loadSettings();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Hanafi'),
              value: 'hanafi',
              groupValue: _settings['madhab'],
              onChanged: (value) async {
                if (value != null) {
                  await _prayerService.saveMadhab(value);
                  await _loadSettings();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHighLatitudeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('High Latitude Rule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Middle of the Night'),
              value: 'middle_of_the_night',
              groupValue: _settings['high_latitude_rule'],
              onChanged: (value) async {
                if (value != null) {
                  await _prayerService.saveHighLatitudeRule(value);
                  await _loadSettings();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Seventh of the Night'),
              value: 'seventh_of_the_night',
              groupValue: _settings['high_latitude_rule'],
              onChanged: (value) async {
                if (value != null) {
                  await _prayerService.saveHighLatitudeRule(value);
                  await _loadSettings();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Twilight Angle'),
              value: 'twilight_angle',
              groupValue: _settings['high_latitude_rule'],
              onChanged: (value) async {
                if (value != null) {
                  await _prayerService.saveHighLatitudeRule(value);
                  await _loadSettings();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Prayer Time Notifications'),
                  subtitle: const Text('Receive alerts for prayer times'),
                  value: _notificationsEnabled,
                  onChanged: (value) async {
                    setState(() => _notificationsEnabled = value);
                    await _saveSettings();
                  },
                ),
                SwitchListTile(
                  title: const Text('Adhkar Notifications'),
                  subtitle: const Text('Receive morning and evening reminders'),
                  value: _adhkarNotificationsEnabled,
                  onChanged: _notificationsEnabled
                      ? (value) async {
                          setState(() => _adhkarNotificationsEnabled = value);
                          await _saveSettings();
                        }
                      : null,
                ),
              ],
            ),
          ),
          _buildCalculationMethodSettings(),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Language'),
                  subtitle:
                      Text(_selectedLanguage == 'en' ? 'English' : 'Arabic'),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    onChanged: (value) async {
                      if (value != null) {
                        setState(() => _selectedLanguage = value);
                        await _saveSettings();
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'ar',
                        child: Text('Arabic'),
                      ),
                    ],
                  ),
                ),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Toggle dark theme'),
                  value: _darkMode,
                  onChanged: (value) async {
                    setState(() => _darkMode = value);
                    themeProvider.toggleTheme();
                    await _saveSettings();
                  },
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('About'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Salah',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2024',
                      children: [
                        const Text(
                          'A comprehensive Islamic app for prayer times, '
                          'Quran, Hadith, and daily remembrance.',
                        ),
                      ],
                    );
                  },
                ),
                ListTile(
                  title: const Text('Reset All Settings'),
                  trailing: const Icon(Icons.restore),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Settings?'),
                        content: const Text(
                          'This will reset all settings to their default values. '
                          'This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('RESET'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      await _loadSettings();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
