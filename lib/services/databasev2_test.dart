import 'package:firebase_database/firebase_database.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';


final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

DatabaseReference saveWorkout(WeightWorkout workout) {
  var id = databaseReference.child('weightWorkouts/').push();
  id.set(workout.toJson());
  return id;
}
