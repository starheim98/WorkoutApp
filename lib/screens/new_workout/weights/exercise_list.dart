import 'package:flutter/cupertino.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'exercise_tile.dart';

class ExerciseList extends StatefulWidget {
  WeightWorkout workout;

  ExerciseList({Key? key, required this.workout}) : super(key: key);

  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.workout.getExercises().length,
      itemBuilder: (BuildContext context, int index) {
        return ExerciseTile(
          exercise: widget.workout.getExercises()[index],
          deleteExercise: removeExercise,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
    );
  }

  void removeExercise(Exercise exercise) {
    setState(() {
      widget.workout.removeExercise(exercise);
    });
  }
}
