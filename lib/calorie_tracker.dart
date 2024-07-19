import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalorieTrackerScreen(),
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.greenAccent),
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
        ),
      ),
    );
  }
}

class CalorieTrackerScreen extends StatefulWidget {
  @override
  _CalorieTrackerScreenState createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> with SingleTickerProviderStateMixin {
  double calorieIntake = 0.0; // Initial calorie intake
  double maxCalories = 2500.0; // Maximum calories for the day (example)
  bool breakfastChecked = false;
  bool lunchChecked = false;
  bool dinnerChecked = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updateCalories(double calories) {
    setState(() {
      calorieIntake += calories;
      if (calorieIntake > maxCalories) {
        calorieIntake = maxCalories; // Limit intake to maxCalories
      }
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker', style: Theme.of(context).textTheme.headlineLarge),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                // Picture
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      'assets/Eating_donuts-bro.png', // Ensure this is the correct path and filename
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                // Radial progress
                Expanded(
                  child: RadialProgress(
                    height: 150.0,
                    width: 150.0,
                    progress: calorieIntake / maxCalories,
                    animationController: _animationController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            // Calorie box
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFFDAB9FF), // Pale purple color
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Today\'s Progress',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Calories Consumed: ${calorieIntake.toInt()} / ${maxCalories.toInt()}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white) ?? TextStyle(color: Colors.white), // Text color white
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Meal checkboxes
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  MealCheckBox(
                    meal: 'Breakfast',
                    icon: Icons.free_breakfast,
                    value: breakfastChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        breakfastChecked = newValue!;
                      });
                    },
                  ),
                  MealCheckBox(
                    meal: 'Lunch',
                    icon: Icons.lunch_dining,
                    value: lunchChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        lunchChecked = newValue!;
                      });
                    },
                  ),
                  MealCheckBox(
                    meal: 'Dinner',
                    icon: Icons.dinner_dining,
                    value: dinnerChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        dinnerChecked = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MealCheckBox extends StatelessWidget {
  final String meal;
  final IconData icon;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const MealCheckBox({
    Key? key,
    required this.meal,
    required this.icon,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          SizedBox(width: 10),
          Expanded(
            child: Text(meal, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.secondary,
            checkColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class RadialProgress extends StatelessWidget {
  final double height;
  final double width;
  final double progress;
  final AnimationController animationController;

  const RadialProgress({
    Key? key,
    required this.height,
    required this.width,
    required this.progress,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: RadialPainter(progress: progress * animationController.value),
          size: Size(width, height),
        );
      },
    );
  }
}

class RadialPainter extends CustomPainter {
  final double progress;

  RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Paint progressPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, backgroundPaint);

    double angle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, angle, false, progressPaint);

    // Draw percentage text
    double percentage = (progress * 100).toInt().toDouble();
    TextSpan span = TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
      text: '${percentage.toInt()}%',
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
