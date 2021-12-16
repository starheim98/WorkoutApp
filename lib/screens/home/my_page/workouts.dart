import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:workout_app/screens/home/my_page/workout_details/run_details.dart';
import 'package:workout_app/screens/home/my_page/workout_details/weight_details.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:workout_app/shared/dialogues.dart';

import '../../../top_secret.dart';

class MyWorkouts extends StatefulWidget {
  const MyWorkouts({Key? key}) : super(key: key);

  @override
  _MyWorkoutsState createState() => _MyWorkoutsState();
}

class _MyWorkoutsState extends State<MyWorkouts> {
  DatabaseService? databaseService;
  List<WeightWorkout> weightWorkouts = [];
  int toggleValue = 0;
  Color activeColor = const Color(0xff4574EB);

  //Run Data
  MapController? mapController;
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
    if (mounted) {
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
          return runTile(
              runWorkouts[index],
              LatLng(runWorkouts[index].getPoints().last.latitude,
                  runWorkouts[index].getPoints().last.longitude),
              getPoints(runWorkouts[index]));
        },
      )
    ];

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ToggleSwitch(
              minWidth: 125,
              initialLabelIndex: _selectedIndex,
              totalSwitches: 2,
              activeBgColors: const [
                [Color(0xff4574EB), Color(0xff005FB7)],
                [Color(0xffC9082B), Color(0xff6C0A39)]
              ],
              labels: const ["Weights", "Runs"],
              onToggle: (index) => {toggleStuff(index)},
            ),
          ),
          workoutChoice.elementAt(_selectedIndex),
        ],
      ),
    );
  }

  void toggleStuff(int index) {
    setState(() => {
          _selectedIndex = index,
        });
  }

  runTile(RunWorkout runWorkout, LatLng latLng, List<LatLng> points) => Card(
      child: ListTile(
        onTap: () => runDetailRoute(runWorkout),
        subtitle: Row(children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  runWorkout.title,
                  gradientDirection: GradientDirection.btt,
                  colors: const [
                    Color(0xFFC9082B),
                    Color(0xFF6C0A39),
                  ],
                  style: tileTitle,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Text("Date: " + runWorkout.getDate(),
                    style: durationDistanceAvgPaceText),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Text("Duration: " + runWorkout.getDuration(),
                    style: durationDistanceAvgPaceText),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              child: FlutterMap(
                options: MapOptions(
                  center: latLng,
                  zoom: 13.0,
                ),
                mapController: mapController,
                layers: [
                  tileLayerOptions,
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                          points: points, strokeWidth: 4.0, color: Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          )
        ]),
        leading: Image.asset('lib/assets/run.png', height: 40),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            var result = await Dialogues().confirmDeleteDialogue(
                context,
                "Delete workout",
                "Are you sure you want to permanently remove the workout?");
            if (result) {
              deleteWorkout(runWorkout.id, false);
            }
          },
        ),
      ));

  workoutTile(WeightWorkout weightWorkout) => Card(
        child: ListTile(
          subtitle: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  weightWorkout.name!,
                  gradientDirection: GradientDirection.btt,
                  colors: const [
                    Color(0xFF4574EB),
                    Color(0XFF005FB7),
                  ],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16+2),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Text("Date: " + weightWorkout.getDate()!,
                    style: durationDistanceAvgPaceText),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Text("Duration: " + weightWorkout.getDuration(),
                    style: durationDistanceAvgPaceText),
              ],
            ),
          ]),
          leading: Image.asset('lib/assets/weight.png', height: 51),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              var result = await Dialogues().confirmDeleteDialogue(
                  context,
                  "Delete workout",
                  "Are you sure you want to permanently remove the workout?");
              if (result) {
                deleteWorkout(weightWorkout.id!, true);
              }
            },
          ),
          onTap: () => workoutDetailRoute(weightWorkout),
        ),
      );

  deleteWorkout(String id, bool isWeighWorkout) {
    if (isWeighWorkout) {
      databaseService!.deleteWorkout(id);
    } else {
      databaseService!.deleteRun(id);
    }
    if (mounted) {
      setState(() {
        fetchData();
      });
    }
  }

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
            builder: (context) =>
                RunWorkoutDetailsPage(runWorkout: runWorkout)));
  }
}
