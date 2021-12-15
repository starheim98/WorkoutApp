import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_set.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/models/weight_lifting/workout_template.dart';
import 'dart:convert';

import 'package:workout_app/screens/home/my_page/graph.dart';


class DatabaseService {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // collection reference
  final CollectionReference weightWorkoutCollection =
  FirebaseFirestore.instance.collection('weight_workouts');
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('user');
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference runsCollection =
  FirebaseFirestore.instance.collection('runs');
  final CollectionReference templateCollection =
  FirebaseFirestore.instance.collection('template');


  Future<List<RunWorkout>> getRunsData() async {
    QuerySnapshot snapshot = await runsCollection.where(
        'userId', isEqualTo: uid).get();
    List<RunWorkout> runWorkouts = [];
    for (var document in snapshot.docs) {
      RunWorkout runWorkout =
      RunWorkout.fromJson(document.data() as Map<String, dynamic>);
      runWorkouts.add(runWorkout);
    }
    return runWorkouts;
  }

  Future<List<AccountData>> findAccounts(String query) async {
    List<AccountData> foundAccouts = [];
    QuerySnapshot snapshot = await usersCollection.get();
    for (var doc in snapshot.docs) {
      var json = doc.data() as Map<String, dynamic>;
      String firstName = json["firstName"];
      String lastName = json["lastName"];
      if (query.isNotEmpty &&
          (firstName.toLowerCase().startsWith(query.toLowerCase())
              || lastName.toLowerCase().startsWith(query.toLowerCase()))) {
        if (json['uid'] != uid) {
          foundAccouts.add(AccountData.fromJson(json));
        }
        if (foundAccouts.length >= 10) {
          break;
        }
      }
    }
    return foundAccouts;
  }

  Future getFriendsWorkouts() async {
    var workouts = [];
    List<RunWorkout> runWorkouts = [];
    List<WeightWorkout> weightWorkouts = [];

    // get collection of friends
    AccountData user = await getThisUser();
    for (String friend in user.friends) {
      QuerySnapshot runSnapshot = await runsCollection.where(
          'userId', isEqualTo: friend).get();
      QuerySnapshot weightSnapshot = await weightWorkoutCollection.where(
          'userId', isEqualTo: friend).get();

      for (var document in runSnapshot.docs) {
        RunWorkout runWorkout =
        RunWorkout.fromJson(document.data() as Map<String, dynamic>);
        runWorkouts.add(runWorkout);
      }
      for (var document in weightSnapshot.docs) {
        WeightWorkout weightWorkout =
        WeightWorkout.fromJson(document.data() as Map<String, dynamic>);
        weightWorkouts.add(weightWorkout);
      }
    }
    return List.from(runWorkouts)
      ..addAll(weightWorkouts);
  }

  Future<bool> followUser(String friendUid) async {
    var userDoc = await usersCollection.doc(uid).get();
    var userJson = userDoc.data() as Map<String, dynamic>;
    AccountData user = AccountData.fromJson(userJson);

    if (!user.friends.contains(friendUid)) {
      user.addFriend(friendUid);
      usersCollection.doc(user.uid).update({"friends": user.friends});
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unfollowUser(String friendUid) async {
    var userDoc = await usersCollection.doc(uid).get();
    var userJson = userDoc.data() as Map<String, dynamic>;
    AccountData user = AccountData.fromJson(userJson);

    if (user.friends.contains(friendUid)) {
      user.unfollowFriend(friendUid);
      usersCollection.doc(user.uid).update({"friends": user.friends});
      return true;
    } else {
      return false;
    }
  }

  /// Easy.
  Future addWeightWorkout(WeightWorkout weightWorkout) async {
    var exerciseJson = json.decode(json.encode(weightWorkout.getExercises()));
    DocumentReference userReference = userCollection.doc(uid);

    return weightWorkoutCollection
        .add({
      'name': weightWorkout.name,
      'date': weightWorkout.date,
      'duration': weightWorkout.duration,
      'exercises': exerciseJson,
      'userId': uid.toString(),
      'id': "",
    })
        .then((value) =>
        weightWorkoutCollection.doc(value.id).update({"id": value.id}))
        .catchError((error) => print("Failed to add workout $error"));
  }

  Future<List<WeightWorkout>> getWeightWorkouts() async {
    List<WeightWorkout> weightWorkouts = [];
    QuerySnapshot snapshot = await weightWorkoutCollection.where(
        'userId', isEqualTo: uid).get();
    for (var document in snapshot.docs) {
      WeightWorkout weightWorkout =
      WeightWorkout.fromJson(document.data() as Map<String, dynamic>);
      weightWorkouts.add(weightWorkout);
    }
    return weightWorkouts;
  }

  Future saveRun(String title, String desc, String duration, double distance,
      List<GeoPoint> points) async {
    if (title.isEmpty) title = "Went for a run today!";
/*    if(distance == 0.0){
      distance = 0.0001;
    }*/

    return runsCollection.add({
      "title": title,
      "description": desc,
      "date": DateTime.now().toString(),
      "duration": duration,
      "distance": distance.toString(),
      "geopoints": points,
      "userId": uid.toString(),
      'id': "",
    })
        .then((value) => runsCollection.doc(value.id).update({"id": value.id}))
        .catchError((error) => print("Failed to add run workout $error"));
  }

  Future<AccountData> getThisUser() async {
    var user = await usersCollection.doc(uid).get();
    var userJson = user.data() as Map<String, dynamic>;
    AccountData account = AccountData.fromJson(userJson);
    return account;
  }

  Future<AccountData> getUser(String uid) async {
    var user = await usersCollection.doc(uid).get();
    var userJson = user.data() as Map<String, dynamic>;
    AccountData account = AccountData.fromJson(userJson);
    return account;
  }

  Future<void> deleteWorkout(String id) async {
    await weightWorkoutCollection.doc(id).delete();
  }

  Future<void> deleteRun(String id) async {
    await runsCollection.doc(id).delete();
    print("Deleted run: " + id);
  }

  Future<List<DateAndWeight>> getExerciseData(String exercise) async {
    List<DateAndWeight> data = [];
    QuerySnapshot snapshot = await weightWorkoutCollection.where(
        'userId', isEqualTo: uid).get();
    for (var document in snapshot.docs) {
      WeightWorkout workout = WeightWorkout.fromJson(
          document.data() as Map<String, dynamic>);
      for (Exercise ex in workout.exercises) {
        if (ex.name == exercise) {
          int max = 0;
          for (WeightSet set in ex.sets!) {
            if (set.getWeight() > max) {
              max = set.getWeight();
            }
          }
          data.add(DateAndWeight(DateTime.parse(workout.date!), max));
        }
      }
    }
    return data;
  }

  Future addTemplate(WorkoutTemplate template) async {
    return templateCollection.add({
      "name": template.name,
      "exercises": template.exercises,
      "userId": uid.toString(),
      'id': "",
    })
        .then((value) =>
        templateCollection.doc(value.id).update({"id": value.id}))
        .catchError((error) => print("Failed to add template $error"));
  }

  Future<List<WorkoutTemplate>> getTemplates() async {
    List<WorkoutTemplate> templates = [];
    QuerySnapshot snapshot = await templateCollection.where(
        'userId', isEqualTo: uid).get();
    for (var document in snapshot.docs) {
      WorkoutTemplate workoutTemplate =
      WorkoutTemplate.fromJson(document.data() as Map<String, dynamic>);
      templates.add(workoutTemplate);
    }
    return templates;
  }

  Future deleteTemplate(String id) async {
    await templateCollection.doc(id).delete();
  }
}