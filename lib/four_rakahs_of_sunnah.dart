import 'package:flutter/material.dart';

class FourRakahsOfSunnah extends StatelessWidget {
  const FourRakahsOfSunnah({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("4 Rak'as of Fard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Learn to Pray 4 Rak'as of Fard"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Return'),
            ),
          ],
        ),
      ),
    );
  }
}
