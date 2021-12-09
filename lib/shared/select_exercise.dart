import 'package:flutter/material.dart';

class SelectExercise extends StatelessWidget {
  const SelectExercise({Key? key}) : super(key: key);

  static const List<String> exerciseCategories = [
    "Chest",
    "Back",
    "Legs",
    "Shoulders"
  ];

  static const List<String> chestExercises = [
    "Benchpress",
    "Dummbell press",
    "Incline dumbell press",
    "Cable crossover"
  ];
  static const List<String> backExercises = [
    "Pulldowns",
    "Seated row",
    "Pullups",
    "Barbell row"
  ];
  static const List<String> legExercies = ["Squat"];
  static const List<String> shoulderExercices = ["Military press"];
  static const List<List<String>> exercices = [
    chestExercises,
    backExercises,
    legExercies,
    shoulderExercices
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select exercise"),
      ),
      body: ListView.builder(
        itemCount: exerciseCategories.length,
        itemBuilder: (_, index) {
          return Card(
            child: ListTile(
              title: Text(exerciseCategories[index]),
              trailing: const Icon(Icons.arrow_forward),
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
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (_, index) {
          return Card(
            child: ListTile(
              title: Text(exercises[index]),
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
