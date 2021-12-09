
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/template.dart';

class WeightWorkout {
  String? _name;
  String? _date;
  int _duration = 0;
  List<Exercise> _exercises = [];
  String? _uid;
  String? _id;

  /// Initializes an empty workout session
  WeightWorkout() {
    _date = DateTime.now().toString();
  }

  /// Initializes a workout session from existing template
  WeightWorkout.template(Template template){
    _date = DateTime.now().toString();
    _name = template.getName();
    _exercises = template.getExercices();
  }

  WeightWorkout.complete(this._name, this._date, this._duration, this._exercises, this._uid, this._id);

  factory WeightWorkout.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    String date = json['date'];
    int duration = json['duration'];
    List<Exercise> exercices = [];
    for (var exercise in json['exercises']){
      exercices.add(Exercise.fromJson(exercise));
    }
    String uid = json['userId'];
    String id = json['id'];
    return WeightWorkout.complete(name, date, duration, exercices, uid, id);
  }

  String? get id => _id;

  String? get uid => _uid;

  String? get date => _date;

  void addExercise(Exercise exercise){
    _exercises.add(exercise);
  }

  void removeExercise(Exercise exercise){
    _exercises.remove(exercise);
  }

  void finishWorkout(){
    _duration = DateTime.now().difference(DateTime.parse(date!)).inMinutes;
  }

  List<Exercise> getExercises(){
    return _exercises;
  }

  String? get name => _name;

  String? getDate(){
    return _date;
  }

  void setName(String value) {
    _name = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'date': _date,
      'duration': _duration,
      'exercises': exercises.toList()
    };
  }

  @override
  String toString() {
    return 'WeightWorkout{name: $_name, date: $_date, duration: $_duration, exercises: $_exercises}';
  }

  int get duration => _duration;

  List<Exercise> get exercises => _exercises;
}

