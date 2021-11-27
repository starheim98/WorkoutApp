import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_set.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';

// final DatabaseReference databaseReference =
//     FirebaseDatabase.instance.reference();
// final CollectionReference userCollection =
//     FirebaseFirestore.instance.collection('user');
// final CollectionReference weightWorkoutCollection =
//     FirebaseFirestore.instance.collection('weight_workouts');
//
// DatabaseReference saveWorkout(WeightWorkout workout) {
//   var id = databaseReference.child('weightWorkouts/').push();
//   id.set(workout.toJson());
//   return id;
// }
//
//
// /// Easy.
// Future addWeightWorkout(WeightWorkout weightWorkout, String uid) async {
//   var exerciseJson = json.decode(json.encode(weightWorkout.getExercises()));
//   DocumentReference userReference = userCollection.doc(uid);
//   return weightWorkoutCollection
//       .add({
//         'name': weightWorkout.name,
//         'startDate': weightWorkout.startDate.toString(),
//         'duration': weightWorkout.duration,
//         'exercises': exerciseJson,
//         'userId' : userReference,
//       })
//       .then((value) => print("added workout"))
//       .catchError((error) => print("Failed to add workout $error"));
// }
//
