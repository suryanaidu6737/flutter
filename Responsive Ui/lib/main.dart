import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Responsive UI"),
        ),
        body: Center(
          child: width < 600
              ? const Text(
                  "Mobile Screen",
                  style: TextStyle(fontSize: 25),
                )
              : const Text(
                  "Large Screen",
                  style: TextStyle(fontSize: 25),
                ),
        ),
      ),
    );
  }
}
