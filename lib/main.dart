import 'package:flutter/material.dart';
import 'first_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Prayer App',
      home: FirstScreen(),
    );
  }
}





















// import 'package:flutter/material.dart';
// import 'fajr_prayer_fard.dart';
// import 'dhuhr_prayer_fard';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Prayer App',
//       home: FirstScreen(),
//     );
//   }
// }

// class FirstScreen extends StatelessWidget {
//   const FirstScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Prayer Times')),
//       body: Center(
//         child: ListView(
//           padding: const EdgeInsets.all(16.0),
//           children: [
//             buildButton(context, 'Fajr', const FajrPrayerFard()),
//             buildButton(
//               context,
//               'Dhuhr',
//             ),
//             buildButton(context, 'Asr'),
//             buildButton(context, 'Maghrib'),
//             buildButton(context, 'Isha'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget buildButton(BuildContext context, String title, Widget screen) {
//   return ElevatedButton(
//     onPressed: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => screen,
//         ),
//       );
//     },
//     child: Text(title),
//   );
// }
