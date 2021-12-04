import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:workout_app/screens/home/my_page/workout_details/run_details.dart';
import 'package:workout_app/screens/home/my_page/workout_details/weight_details.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';

import '../../../top_secret.dart';

class MyWorkouts extends StatefulWidget {
  const MyWorkouts({Key? key}) : super(key: key);

  @override
  _MyWorkoutsState createState() => _MyWorkoutsState();
}

class _MyWorkoutsState extends State<MyWorkouts> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseService? databaseService;
  List<WeightWorkout> weightWorkouts = [];
  int toggleValue = 0;

  //Run Data
  MapController? mapController;
  double longitude = 6.235902420311039;
  double latitude = 62.472207764237886;
  List<RunWorkout> runWorkouts = [];
  //
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
    fetchData();
  }

  Future fetchData() async {
    var weightWorkoutData = await databaseService!.getWeightWorkouts();
    var runWorkoutData = await databaseService!.getRunsData();
    if(mounted){
      setState(() {
        weightWorkouts = weightWorkoutData;
        runWorkouts = runWorkoutData;
      });
    }
  }

  /// Extracts the Geopoints from DB and translate to LatLng, making it insertable
  /// in the flutter map widget.
  List<LatLng> getPoints(RunWorkout runWorkout) {
    try {
      List<LatLng> points = <LatLng>[];
      for (GeoPoint geopoint in runWorkout.geopoints) {
        points.add(LatLng(geopoint.latitude, geopoint.longitude));
      }
      return points;
    } on Exception catch (e) {
      return []; //If there is no run connected to the data there will be no data to draw.
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> workoutChoice = <Widget>[
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: weightWorkouts.length,
        itemBuilder: (BuildContext context, int index) {
          return workoutTile(weightWorkouts[index]);
        },
      ),
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: runWorkouts.length,
        itemBuilder: (BuildContext context, int index) {
          return runTile(runWorkouts[index], LatLng(latitude, longitude), getPoints(runWorkouts[index]));
        },
      )
    ];

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ToggleSwitch(
                initialLabelIndex: _selectedIndex,
                totalSwitches: 2,
                activeBgColor: const [Colors.amber],
                labels: const ["Weights", "Runs"],
                onToggle: (index) => {
                  toggleStuff(index)
                },
              ),
          ),
          workoutChoice.elementAt(_selectedIndex),
        ],
      ),
    );
  }

  void toggleStuff(int index){
  setState(() => {
    _selectedIndex = index,
  });
}
  workoutTile(WeightWorkout weightWorkout) => Card(
        child: ListTile(
          title: Text(weightWorkout.name!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Date: " + weightWorkout.date!),
              Text("Duration: " + weightWorkout.duration.toString() + " min")
            ],
          ),
          leading: const Icon(Icons.fitness_center),
          trailing: const Icon(Icons.more_vert),
          onTap: () => workoutDetailRoute(weightWorkout),
        ),
      );

  workoutDetailRoute(weightWorkout) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutDetailPage(workout: weightWorkout)));
  }

 runDetailRoute(runWorkout) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RunWorkoutDetailsPage(runWorkout: runWorkout)));
  }

  // SingleChildScrollView runListView(context) => SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           ListView.builder(
  //             physics: const NeverScrollableScrollPhysics(),
  //             scrollDirection: Axis.vertical,
  //             shrinkWrap: true,
  //             itemCount: runWorkouts.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return runTile(runWorkouts[index], LatLng(latitude, longitude), getPoints(runWorkouts[index]));
  //             },
  //           )
  //         ],
  //       ),
  //     );

  runTile(RunWorkout runWorkout, LatLng latLng, List<LatLng> points) => Card (
      child: ListTile(
        title: Text(runWorkout.title),
        onTap: () =>  runDetailRoute(runWorkout) ,
        subtitle: Text("Desc: " + runWorkout.description +
            ". Duration: " + runWorkout.duration + ". Distance: "
            + runWorkout.distance),
        leading: SizedBox(
          height: 50,
          width: 50,
          child: FlutterMap(
            options: MapOptions(
              center: latLng,
              zoom: 15.0,
            ),
            mapController: mapController,
            layers: [
              tileLayerOptions,
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: latLng,
                    builder: (ctx) => const Icon(Icons.pin_drop),
                  ),
                ],
              ),
              PolylineLayerOptions(
                polylines: [
                  Polyline(
                      points: points,
                      strokeWidth: 4.0,
                      color: Colors.purple),
                ],
              ),
            ],
          ),
        ),
      )
  );
}
