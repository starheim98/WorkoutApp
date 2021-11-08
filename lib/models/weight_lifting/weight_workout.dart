
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/workout.dart';

class WeightWorkout {
  String? name;
  DateTime? date;
  DateTime? duration;
  List<Exercise>? exercises;


  WeightWorkout(){
    date = DateTime.now();
    exercises = [];
  }

  void addExercise(Exercise exercise){
    exercises!.add(exercise);
  }
}