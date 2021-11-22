import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/template.dart';
import 'package:intl/intl.dart';

class WeightWorkout {
  String? _name;
  DateTime startDate = DateTime.now();
  int duration = 0;
  List<Exercise> exercises = [];
  DatabaseReference? _id;

  /// Initializes an empty workout session
  WeightWorkout();

  /// Initializes a workout session from existing template
  WeightWorkout.template(Template template){
    _name = template.getName();
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

  List<Exercise> getExercises(){
    return exercises;
  }

  String? get name => _name;

  String getDate(){
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(startDate);
  }

  void setName(String value) {
    _name = value;
  }

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startDate': startDate,
      'duration': duration,
      'exercises': exercises
    };
  }

  @override
  String toString() {
    return 'WeightWorkout{name: $_name, startDate: $startDate, duration: $duration, exercises: $exercises}';
  }
}