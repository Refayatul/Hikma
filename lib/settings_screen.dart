import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';
import 'services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  bool _prayerNotifications = true;
  String _calculationMethod = 'Muslim World League';
  String _language = 'English';
  double _arabicFontSize = 24;
  double _translationFontSize = 16;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _prayerNotifications = _prefs.getBool('prayerNotifications') ?? true;
      _calculationMethod =
          _prefs.getString('calculationMethod') ?? 'Muslim World League';
      _language = _prefs.getString('language') ?? 'English';
      _arabicFontSize = _prefs.getDouble('arabicFontSize') ?? 24;
      _translationFontSize = _prefs.getDouble('translationFontSize') ?? 16;
    });
  }

  Future<void> _savePrayerNotifications(bool value) async {
    await _prefs.setBool('prayerNotifications', value);
    setState(() => _prayerNotifications = value);

    final notificationService = NotificationService();
    if (value) {
      await notificationService.initialize();
    } else {
      await notificationService.cancelAllNotifications();
    }
  }

  Future<void> _saveCalculationMethod(String value) async {
    await _prefs.setString('calculationMethod', value);
    setState(() => _calculationMethod = value);
  }

  Future<void> _saveLanguage(String value) async {
    await _prefs.setString('language', value);
    setState(() => _language = value);
  }

  Future<void> _saveArabicFontSize(double value) async {
    await _prefs.setDouble('arabicFontSize', value);
    setState(() => _arabicFontSize = value);
  }

  Future<void> _saveTranslationFontSize(double value) async {
    await _prefs.setDouble('translationFontSize', value);
    setState(() => _translationFontSize = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                );
              },
            ),
          ),
          ListTile(
            title: const Text('Prayer Time Notifications'),
            trailing: Switch(
              value: _prayerNotifications,
              onChanged: _savePrayerNotifications,
            ),
          ),
          ListTile(
            title: const Text('Prayer Calculation Method'),
            subtitle: Text(_calculationMethod),
            onTap: () => _showCalculationMethodDialog(),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_language),
            onTap: () => _showLanguageDialog(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Arabic Font Size'),
                Slider(
                  value: _arabicFontSize,
                  min: 16,
                  max: 40,
                  divisions: 12,
                  label: _arabicFontSize.round().toString(),
                  onChanged: (value) => _saveArabicFontSize(value),
                ),
                const Text('Translation Font Size'),
                Slider(
                  value: _translationFontSize,
                  min: 12,
                  max: 24,
                  divisions: 6,
                  label: _translationFontSize.round().toString(),
                  onChanged: (value) => _saveTranslationFontSize(value),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Clear Cache'),
            leading: const Icon(Icons.delete_outline),
            onTap: () => _showClearCacheDialog(),
          ),
          ListTile(
            title: const Text('About'),
            leading: const Icon(Icons.info_outline),
            onTap: () => _showAboutDialog(),
          ),
        ],
      ),
    );
  }

  void _showCalculationMethodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Prayer Calculation Method'),
          children: [
            'Muslim World League',
            'Islamic Society of North America',
            'Egyptian General Authority of Survey',
            'Umm Al-Qura University, Makkah',
            'University of Islamic Sciences, Karachi',
          ].map((method) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _saveCalculationMethod(method);
              },
              child: Text(method),
            );
          }).toList(),
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Language'),
          children: [
            'English',
            'Arabic',
            'Urdu',
            'Indonesian',
            'Turkish',
          ].map((language) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _saveLanguage(language);
              },
              child: Text(language),
            );
          }).toList(),
        );
      },
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
            'This will clear all cached data including bookmarks and reading progress. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                await LocalStorageService.clearAllData();
                await _prefs.clear();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared')),
                  );
                }
              },
              child: const Text('CLEAR'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Islamic Guide',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(size: 64),
      children: [
        const Text(
          'A comprehensive Islamic app featuring prayer times, Quran, Qibla direction, and Islamic teachings.',
        ),
      ],
    );
  }
}
