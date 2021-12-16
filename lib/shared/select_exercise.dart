import 'package:flutter/material.dart';

import 'constants.dart';

class SelectExercise extends StatelessWidget {
  const SelectExercise({Key? key}) : super(key: key);

  static const List<String> exerciseCategories = [
    "Chest",
    "Back",
    "Legs",
    "Shoulders",
    "Abs",
    "Biceps",
    "Triceps"
  ];

  static const List<String> chestExercises = [
    "Benchpress",
    "Dummbell press",
    "Incline dumbell press",
    "Cable crossover",
    "Flies",
    "Dips"
  ];
  static const List<String> backExercises = [
    "Pulldowns",
    "Seated row",
    "Pullups",
    "Barbell row",
    "Deadlift",
    "Face pulls"
  ];
  static const List<String> legExercies = [
    "Squat",
    "Leg press",
    "Front squat",
    "Lunges",
    "Leg extensions",
    "Calf raises"
  ];
  static const List<String> shoulderExercices = [
    "Military press",
    "Lateral raises",
    "Upright rows"
  ];
  static const List<String> absExercices = [
    "Crunches",
    "Cable crunches",
    "Hip thrust"
  ];
  static const List<String> bicepsExercises = [
    "Barbell curl",
    "Dumbell curl",
    "Drag curl",
    "EZ-bar curl"
  ];
  static const List<String> tricepsExercises = [
    "Pushdowns",
    "Cable purshdown",
    "Triceps extensions"
  ];
  static const List<List<String>> exercices = [
    chestExercises,
    backExercises,
    legExercies,
    shoulderExercices,
    absExercices,
    bicepsExercises,
    tricepsExercises
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Select exercise"),
      ),
      body: ListView.builder(
        itemCount: exerciseCategories.length,
        itemBuilder: (_, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: ListTile(
              title: Text(
                exerciseCategories[index],
                style: const TextStyle(
                    color: Color(0xff245CB6), fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectedCategory(
                            category: exerciseCategories[index],
                            exercises: exercices[index])));
              },
            ),
          );
        },
      ),
    );
  }
}

class SelectedCategory extends StatelessWidget {
  final String category;
  final List<String> exercises;

  const SelectedCategory(
      {Key? key, required this.exercises, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (_, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: ListTile(
              title: Text(
                exercises[index],
                style: const TextStyle(
                    color: Color(0xff245CB6), fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context, exercises[index]);
                Navigator.pop(context, exercises[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
