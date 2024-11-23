import 'package:flutter/material.dart';

class FourRakahsOfFard extends StatelessWidget {
  const FourRakahsOfFard({super.key});

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
            const Text("Learn to Pray Four Rak'as of Fard"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Return"),
            ),
          ],
        ),
      ),
    );
  }
}
