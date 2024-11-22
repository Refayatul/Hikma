import 'package:flutter/material.dart';

void main() {
  runApp(const FirstScreen());
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: ListView(
          children: [
            buildButton('Fajr'),
            buildButton('Dhuhr'),
            buildButton('Asr'),
            buildButton('Magrib'),
            buildButton('Isha'),
          ],
        ),
      )),
    );
  }
}

Widget buildButton(String title) {
  return ElevatedButton(
    onPressed: () {},
    child: Text(title),
  );
}
