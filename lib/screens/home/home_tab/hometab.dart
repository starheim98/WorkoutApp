import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';

import '../../../top_secret.dart';

class HomeTab extends StatefulWidget {
  List<RunWorkout> runWorkouts;
  List<WeightWorkout> weightWorkouts;
  List<dynamic> friendsWorkouts;

  HomeTab({Key? key, required this.runWorkouts, required this.weightWorkouts, required this.friendsWorkouts})
      : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DatabaseService databaseService = DatabaseService();
  String currentName = "apekatt";

  @override
  Widget build(BuildContext context) {
    List<RunWorkout> runWorkouts = widget.runWorkouts;
    List<WeightWorkout> weightWorkouts = widget.weightWorkouts;
    var friendsWorkouts = widget.friendsWorkouts;

    print(friendsWorkouts.length);

    var workoutsList = List.from(runWorkouts)
      ..addAll(weightWorkouts)
      ..addAll(friendsWorkouts);
    workoutsList.sort((a, b) => a.date.compareTo(b.date)); //EZCLAP


    return ListView.builder(
      itemCount: workoutsList.length,
      itemBuilder: (BuildContext context, int index) {
        getName(workoutsList[index].uid);
        if (workoutsList[index] is RunWorkout) {
          return customRunTile(workoutsList[index], currentName);
        } else if (workoutsList[index] is WeightWorkout) {
          return workoutTile(workoutsList[index]);
        }
        return const Text("No data");
      },
    );
  }

  Future<void> getName(String userID) async {
    var result = await databaseService.getUser(userID);
    if(mounted){
      setState(() {
        currentName = result.getName();
      });
    }
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
        ),
      );

  runTile(RunWorkout runWorkout) => Card(
          child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 1,
        child: ListTile(
          title: Text(runWorkout.title),
          subtitle: Text("Desc: " +
              runWorkout.description +
              ". \nDuration: " +
              runWorkout.duration +
              ". \nDistance: " +
              runWorkout.distance),

          leading: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.3,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(62.472207764237886, 6.235902420311039),
                zoom: 15.0,
              ),
              layers: [
                tileLayerOptions,
                PolylineLayerOptions(
                  polylines: [
                    Polyline(
                        points: runWorkout.getPoints(),
                        strokeWidth: 4.0,
                        color: Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ),
      ));


  customRunTile(RunWorkout runWorkout, String name) => Card(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 1,
        child: Row(
          children: [
            Container(
              width:  MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.all(5),
              child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(62.472207764237886, 6.235902420311039),
                    zoom: 15.0,
                  ),
                  layers: [
                    tileLayerOptions,
                    PolylineLayerOptions(
                      polylines: [
                        Polyline(
                            points: runWorkout.getPoints(),
                            strokeWidth: 4.0,
                            color: Colors.purple),
                      ],
                    ),
                  ],
                ),
            ),
            SizedBox(width: 10),
            Column(
              children: [
                  Text("name: " + name),
                  Text("Title: " + runWorkout.title),
                  Text("\nDescription: " + runWorkout.description),
                  Text("Time spent: " + runWorkout.duration),
                  Text("Distance: " + runWorkout.distance),
                  Text("\nDate: " + runWorkout.date),
              ],
            )
          ],
          ),
        ),
  );
}
