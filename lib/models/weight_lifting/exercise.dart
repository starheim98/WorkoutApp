
import 'package:workout_app/models/weight_lifting/weight_set.dart';

class Exercise{
  final String name;
  List<WeightSet>? sets;

  Exercise(this.name){
    sets = [];
  }

  Exercise.complete(this.name, this.sets);

  factory Exercise.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    List<WeightSet> sets = [];
    for (var set in json['sets']) {
      sets.add(WeightSet.fromJson(set));
    }
    return Exercise.complete(name, sets);
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets
    };
  }
}

//Squats
// 100kg x 4
// 100kg x 4
// 100kg x 4