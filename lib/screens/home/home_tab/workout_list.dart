import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';

import '../../../top_secret.dart';

class HomeTab extends StatefulWidget {
  List<RunWorkout> runWorkouts;
  List<WeightWorkout> weightWorkouts;

  HomeTab(
      {Key? key, required this.runWorkouts, required this.weightWorkouts})
      : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    List<RunWorkout> runWorkouts = widget.runWorkouts;
    List<WeightWorkout> weightWorkouts = widget.weightWorkouts;

    var newList = List.from(runWorkouts)..addAll(weightWorkouts);
    newList.sort((a, b) => a.date.compareTo(b.date)); //EZCLAP

    return ListView.builder(
      itemCount: newList.length,
      itemBuilder: (BuildContext context, int index) {
        if(newList[index] is RunWorkout){
          return runTile(newList[index]);
        } else if (newList[index] is WeightWorkout){
          return workoutTile(newList[index]);
        }
        return const Text("No data");
      },
    );
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
          child: ListTile(
        title: Text(runWorkout.title),
        subtitle: Text("Desc: " +
            runWorkout.description +
            ". Duration: " +
            runWorkout.duration +
            ". Distance: " +
            runWorkout.distance),
        leading: SizedBox(
          height: 50,
          width: 50,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(62.472207764237886, 6.235902420311039),
              zoom: 15.0,
            ),
            layers: [
              tileLayerOptions,
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(62.472207764237886, 6.235902420311039),
                    builder: (ctx) => const Icon(Icons.pin_drop),
                  ),
                ],
              ),
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
      ));
}

