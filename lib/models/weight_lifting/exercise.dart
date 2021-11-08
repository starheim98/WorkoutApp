
class Exercise{
  final String name;
  List<Set>? sets;

  Exercise(this.name){
    sets = [];
  }

  void addSet(Set set){
    sets!.add(set);
  }

  void removeSet(Set set){
    sets!.remove(set);
  }
}