

import 'package:workout_app/models/weight_lifting/exercise.dart';

class Template {
  String name;
  List<Exercise> exercices;

  Template({required this.name, required this.exercices});

  String getName(){
    return name;
  }

  List<Exercise> getExercices(){
    return exercices;
  }


}