import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  final CollectionReference runsCollection =
      FirebaseFirestore.instance.collection('runs');

  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  Future<List<RunWorkout>> getRunsData() async {
    DocumentReference userReference = userCollection.doc(uid);
    QuerySnapshot snapshot = await runsCollection.where('userId', isEqualTo: userReference).get();
    List<RunWorkout> runWorkouts = [];

    for(var document in snapshot.docs){
      RunWorkout runWorkout =
      RunWorkout.fromJson(document.data() as Map<String, dynamic>);
      runWorkouts.add(runWorkout);
    }
    return runWorkouts;
  }

  /// Easy.
  Future addWeightWorkout(WeightWorkout weightWorkout) async {
    var exerciseJson = json.decode(json.encode(weightWorkout.getExercises()));
    DocumentReference userReference = userCollection.doc(uid);
    return weightWorkoutCollection
        .add({
          'name': weightWorkout.name,
          'startDate': weightWorkout.startDate.toString(),
          'duration': weightWorkout.duration,
          'exercises': exerciseJson,
          'userId': userReference,
        })
        .then((value) => print("added workout"))
        .catchError((error) => print("Failed to add workout $error"));
  }

  Future<List<WeightWorkout>> getWeightWorkouts() async {
    List<WeightWorkout> weightWorkouts = [];
    DocumentReference userReference = userCollection.doc(uid);
    QuerySnapshot snapshot = await weightWorkoutCollection.where('userId', isEqualTo: userReference).get();
    for (var document in snapshot.docs) {
      var json = document.data() as Map<String, dynamic>;
      print(json['name']);
      WeightWorkout weightWorkout =
          WeightWorkout.fromJson(document.data() as Map<String, dynamic>);
      weightWorkouts.add(weightWorkout);
    }
    return weightWorkouts;
  }

  //Add LATLNG
  Future saveRun(String title, String desc, Duration duration, double distance, List<GeoPoint> points) async {
    if(title.isEmpty) title = "Went for a run today!";
    DocumentReference userReference = userCollection.doc(uid);

    await runsCollection.doc().set({
      "title" : title,
      "description" : desc,
      "duration" : duration.toString(),
      "distance" : distance.toString(),
      "geopoints" : points,
      "userId" : userReference,
    });
  }
}

/*  Future<List<LatLng>> getLatLngPointData() async {
    DocumentReference userReference = userCollection.doc(uid);
    QuerySnapshot snapshot = await runsCollection.where('userId', isEqualTo: userReference).get();
    List<RunWorkout> runWorkouts = [];

    for(var document in snapshot.docs){
      RunWorkout runWorkout =
      RunWorkout.fromJson(document.data() as Map<String, dynamic>);
      runWorkouts.add(runWorkout);
      print(runWorkout.geopoints);
      print("CUm");
    }
    return runWorkouts;
  }*/
