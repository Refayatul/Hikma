import 'package:flutter/material.dart';

class ThreeRakasOfWitr extends StatelessWidget {
  const ThreeRakasOfWitr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("3 Rak'as of Witr"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Learn to Pray 3 Rak'ahs of Witr"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Return'),
            ),
          ],
        ),
      ),
    );
  }
}
