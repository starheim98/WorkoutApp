
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/template.dart';
import 'package:intl/intl.dart';

class WeightWorkout {
  String? _name;
  final DateTime _startDate = DateTime.now();
  int _duration = 0;
  List<Exercise> _exercises = [];
  DatabaseReference? _id;

  /// Initializes an empty workout session
  WeightWorkout();

  /// Initializes a workout session from existing template
  WeightWorkout.template(Template template){
    _name = template.getName();
    _exercises = template.getExercices();
  }

  WeightWorkout.complete(this._name, this._duration, this._exercises);

  factory WeightWorkout.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    int duration = json['duration'];
    List<Exercise> exercices = [];
    for (var exercise in json['exercises']){
      exercices.add(Exercise.fromJson(exercise));
    }
    return WeightWorkout.complete(name, duration, exercices);
  }

  DateTime get startDate => _startDate;

  void addExercise(Exercise exercise){
    _exercises.add(exercise);
  }

  void removeExercise(Exercise exercise){
    _exercises.remove(exercise);
  }

  void finishWorkout(){
    _duration = DateTime.now().difference(startDate).inMinutes;
  }

  List<Exercise> getExercises(){
    return _exercises;
  }

  String? get name => _name;

  String getDate(){
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(_startDate);
  }

  void setName(String value) {
    _name = value;
  }

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'startDate': _startDate,
      'duration': _duration,
      'exercises': exercises.toList()
    };
  }

  @override
  String toString() {
    return 'WeightWorkout{name: $_name, startDate: $_startDate, duration: $_duration, exercises: $_exercises}';
  }

  int get duration => _duration;

  List<Exercise> get exercises => _exercises;
}

