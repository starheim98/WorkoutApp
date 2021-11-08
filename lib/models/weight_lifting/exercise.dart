
class Exercise{
  final String name;
  List<Set> sets;

  Exercise(this.name, this.sets);

  void addSet(Set set){}

  void removeSet(Set set){
    sets.remove(set);
  }
}