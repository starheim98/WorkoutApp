import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/shared/constants.dart';

class WorkoutDetailPage extends StatefulWidget {
  WeightWorkout workout;
  WorkoutDetailPage({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name!),
      ),
      body: Text("Penis :)"),
    );
  }
}
