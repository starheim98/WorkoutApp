
class WeightSet{
  int _weight = 0;
  int _repetitions = 0;

  WeightSet(this._weight,this._repetitions);
  WeightSet.newSet();

  factory WeightSet.fromJson(Map<String, dynamic> json) {
    return WeightSet(json['weight'], json['repetitions']);
  }

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

  Map<String, dynamic> toJson() {
    return {
      'weight': _weight,
      'repetitions': _repetitions,
    };
  }
}