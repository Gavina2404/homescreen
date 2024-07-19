import 'package:flutter/material.dart';
import 'calorie_tracker.dart'; // Importing CalorieTrackerScreen widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalorieTrackerScreen(), // Setting CalorieTrackerScreen as the home screen
      debugShowCheckedModeBanner: false,
    );
  }
}
