import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';

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

  Future<List<RunWorkout>> getRunsData() async {
    QuerySnapshot snapshot = await runsCollection.where('userId', isEqualTo: uid).get();
    List<RunWorkout> runWorkouts = [];
    for(var document in snapshot.docs){
      RunWorkout runWorkout =
      RunWorkout.fromJson(document.data() as Map<String, dynamic>);
      runWorkouts.add(runWorkout);
    }
    return runWorkouts;
  }

  Future<List<AccountData>> findAccounts(String query) async{
    List<AccountData> foundAccouts = [];
    QuerySnapshot snapshot = await usersCollection.get();
    for (var doc in snapshot.docs) {
      var json = doc.data() as Map<String, dynamic>;
      String firstName = json["firstName"];
      String lastName = json["lastName"];
      if (query.isNotEmpty && (firstName.toLowerCase().startsWith(query.toLowerCase())
          || lastName.toLowerCase().startsWith(query.toLowerCase()))){
        if (json['uid'] != uid) {
          foundAccouts.add(AccountData.fromJson(json));
        }
        if(foundAccouts.length >= 10) {
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
      QuerySnapshot runSnapshot = await runsCollection.where('userId', isEqualTo: friend).get();
      QuerySnapshot weightSnapshot = await weightWorkoutCollection.where('userId', isEqualTo: friend).get();

      for(var document in runSnapshot.docs){
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
    return List.from(runWorkouts)..addAll(weightWorkouts);

  }

  Future<bool> followUser(String friendUid) async {
    var userDoc = await usersCollection.doc(uid).get();
    var userJson = userDoc.data() as Map<String, dynamic>;
    AccountData user = AccountData.fromJson(userJson);

    if(!user.friends.contains(friendUid)){
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

    if(user.friends.contains(friendUid)){
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
        })
        .then((value) => print("added workout"))
        .catchError((error) => print("Failed to add workout $error"));
  }

  Future<List<WeightWorkout>> getWeightWorkouts() async {
    List<WeightWorkout> weightWorkouts = [];
    QuerySnapshot snapshot = await weightWorkoutCollection.where('userId', isEqualTo: uid).get();
    for (var document in snapshot.docs) {
      WeightWorkout weightWorkout =
          WeightWorkout.fromJson(document.data() as Map<String, dynamic>);
      weightWorkouts.add(weightWorkout);
    }
    return weightWorkouts;
  }

  Future saveRun(String title, String desc, String duration, double distance, List<GeoPoint> points) async {
    if(title.isEmpty) title = "Went for a run today!";
    DocumentReference userReference = userCollection.doc(uid);

    await runsCollection.doc().set({
      "title" : title,
      "description" : desc,
      "date" : DateTime.now().toString(),
      "duration" : duration,
      "distance" : distance.toString(),
      "geopoints" : points,
      "userId" : uid.toString(),
    });
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
}
