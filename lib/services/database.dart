import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference weightWorkoutCollection = FirebaseFirestore.instance.collection('weight_workouts');
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  Future updateUserData(String email) async {
    return await weightWorkoutCollection.doc(uid).set({
      'email': email,
    });
  }


  DatabaseReference saveWorkout(WeightWorkout workout) {
    var id = databaseReference.child('weightWorkouts/').push();
    id.set(workout.toJson());
    return id;
  }
}