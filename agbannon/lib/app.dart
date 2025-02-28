// app.dart
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      home: Scaffold(
        appBar: AppBar(title: Text('Bienvenue')),
        body: Center(child: Text('Hello, world!')),
      ),
    );
  }
}
