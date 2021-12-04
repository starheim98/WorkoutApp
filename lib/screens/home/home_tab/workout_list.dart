import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';

import '../../../top_secret.dart';

class HomeWorkoutList extends StatefulWidget {
  List<RunWorkout> runWorkouts;
  HomeWorkoutList({Key? key, required this.runWorkouts})
      : super(key: key);

  @override
  _HomeWorkoutListState createState() => _HomeWorkoutListState();
}

class _HomeWorkoutListState extends State<HomeWorkoutList> {
  double longitude = 6.235902420311039;
  double latitude = 62.472207764237886;

  @override
  Widget build(BuildContext context) {
    List<RunWorkout> runWorkouts = widget.runWorkouts;
    return ListView.builder(
      itemCount: runWorkouts.length,
      itemBuilder: (BuildContext context, int index) {
        return runTile(runWorkouts[index], LatLng(latitude, longitude), getPoints(runWorkouts[index]));
      },
    );
  }

  List<LatLng> getPoints(RunWorkout runWorkout)  {
    try {
      List<LatLng> points = <LatLng>[];
      for (GeoPoint geopoint in runWorkout.geopoints){
        points.add(LatLng(geopoint.latitude, geopoint.longitude));
      }
      return points;
    } on Exception catch (e) {
      return []; //If there is no run connected to the data there will be no data to draw.
    }
  }

  runTile(RunWorkout runWorkout, LatLng latLng, List<LatLng> points) => Card (
      child: ListTile(
        title: Text(runWorkout.title),
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
