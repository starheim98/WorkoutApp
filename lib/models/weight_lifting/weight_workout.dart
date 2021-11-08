
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/template.dart';

class WeightWorkout {
  String? name;
  DateTime startDate = DateTime.now();
  int duration = 0;
  List<Exercise> exercises = [];

  /// Initializes an empty workout session
  WeightWorkout();

  /// Initializes a workout session from existing template
  WeightWorkout.template(Template template){
    name = template.getName();
    exercises = template.getExercices();
  }

  void addExercise(Exercise exercise){
    exercises.add(exercise);
  }

  void removeExercise(Exercise exercise){
    exercises.remove(exercise);
  }

  void finishWorkout(){
    duration = DateTime.now().difference(startDate).inMinutes;
  }
}