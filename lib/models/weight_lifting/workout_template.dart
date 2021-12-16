class WorkoutTemplate {
  String name;
  List<String> exercises = [];
  String userId;
  String? id;

  WorkoutTemplate.create(this.name, this.exercises, this.userId);

  WorkoutTemplate(this.name, this.exercises, this.userId, this.id);

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) {
    String name = json["name"];
    String userId = json["userId"];
    String id = json["id"];
    List<String> exercises = [];
    for (var exercise in json['exercises']) {
      exercises.add(exercise);
    }
    return WorkoutTemplate(name, exercises, userId, id);
  }
}
