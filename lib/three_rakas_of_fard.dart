import 'package:flutter/material.dart';

class ThreeRakasOfFard extends StatelessWidget {
  const ThreeRakasOfFard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("3 Rak'as of Fard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Learn to Pray 3 Rak'ahs of Fard"),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Return"))
          ],
        ),
      ),
    );
  }
}
