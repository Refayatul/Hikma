import 'package:flutter/material.dart';

Widget buildPrayerButton(String title, IconData icon, VoidCallback onPressed) {
  return ElevatedButton.icon(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 60),
      backgroundColor: Colors.deepPurpleAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    icon: Icon(
      icon,
      size: 30,
    ),
    label: Text(
      title,
      style: const TextStyle(fontSize: 20),
    ),
  );
}
