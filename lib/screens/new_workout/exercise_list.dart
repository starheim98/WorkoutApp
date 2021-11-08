
import 'package:flutter/cupertino.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/new_workout/exercise_tile.dart';

class ExerciseList extends StatelessWidget {
  WeightWorkout workout;

  ExerciseList({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: workout.getExercises().length,
        itemBuilder: (BuildContext context, int index) {
          return ExerciseTile(exercise: workout.getExercises()[index]);
        }
    );
  }
}