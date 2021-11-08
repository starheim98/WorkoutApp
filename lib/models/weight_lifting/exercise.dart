
class Exercise{
  final String name;
  List<Set>? sets;

  Exercise(this.name){
    sets = [];
  }

 // [[100,4],[100,4],[100,4]] Exercise 1
  void addSet(Set set){
    sets!.add(set);
  }

  void removeSet(Set set){
    sets!.remove(set);
  }
}

//Squats
// 100kg x 4
// 100kg x 4
// 100kg x 4