
class WeightSet{
  int _weight = 0;
  int _repetitions = 0;

  WeightSet(this._weight,this._repetitions);
  WeightSet.newSet();

  int getWeight(){
    return _weight;
  }

  int getRepetitions(){
    return _repetitions;
  }

  void setWeight(int weight){
    _weight = weight;
  }
  void setRepetitions(int repetitions){
    _repetitions = repetitions;
  }
}