
import 'package:workout_app/models/weight_lifting/weight_set.dart';

class Exercise{
  final String name;
  List<WeightSet>? sets;

  Exercise(this.name){
    sets = [];
  }

  void addSet(){
    sets!.add(WeightSet.newSet());
  }

  void removeSet(WeightSet set){
    sets!.remove(set);
  }

  String getName(){
    return name;
  }

  List<WeightSet>? getSets() {
    return sets;
  }
}

//Squats
// 100kg x 4
// 100kg x 4
// 100kg x 4