import 'package:flutter/material.dart';
import 'package:workout_app/screens/new_workout/weights/workout_templates/template_page.dart';
import 'package:workout_app/screens/new_workout/weights/weightlift_screen.dart';

class WeightLifting extends StatefulWidget {
  const WeightLifting({Key? key}) : super(key: key);


  @override
  State<WeightLifting> createState() => _WeightLiftingState();
}

class _WeightLiftingState extends State<WeightLifting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Weightlifting"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TemplatePage()),
                    )
                  },
                  child: const Text('Select from template'),
                ),
                ElevatedButton(
                  onPressed: () async => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewWorkout()),
                    )
                  },
                  child: const Text('New workout'),
                ),
              ]),
        ));
  }
}