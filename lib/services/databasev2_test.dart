import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';


final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
final CollectionReference weightWorkoutCollection = FirebaseFirestore.instance.collection('weight_workouts');


DatabaseReference saveWorkout(WeightWorkout workout) {
  var id = databaseReference.child('weightWorkouts/').push();
  id.set(workout.toJson());
  return id;
}

Future addWeightWorkout(WeightWorkout weightWorkout) {
  
  return weightWorkoutCollection.add({
    'name': weightWorkout.name,
    'startDate': weightWorkout.startDate.toString(),
    'duration': weightWorkout.duration,
    'exercises': {}
  })
      .then((value) => print("added workout"))
      .catchError((error) => print("Failed to add workout $error"));
}

