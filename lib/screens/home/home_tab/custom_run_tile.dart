import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/screens/home/my_page/workout_details/run_details.dart';
import 'package:workout_app/services/database.dart';

import '../../../top_secret.dart';

class CustomRunTile extends StatefulWidget {
  RunWorkout runWorkout;

  CustomRunTile({Key? key, required this.runWorkout}) : super(key: key);

  @override
  _CustomRunTileState createState() => _CustomRunTileState();
}

class _CustomRunTileState extends State<CustomRunTile> {
  DatabaseService databaseService = DatabaseService();
  RunWorkout? runWorkout;
  String name = "";

  @override
  void initState() {
    getName(widget.runWorkout.uid);
    runWorkout = widget.runWorkout;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RunWorkoutDetailsPage(runWorkout: runWorkout!)),
          )
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 1,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.4,
                padding: EdgeInsets.all(5),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(runWorkout!.getPoints().last.latitude, runWorkout!.getPoints().last.longitude),
                    zoom: 15.0,
                  ),
                  layers: [
                    tileLayerOptions,
                    PolylineLayerOptions(
                      polylines: [
                        Polyline(
                            points: runWorkout!.getPoints(),
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
                  Text("Title: " + runWorkout!.title),
                  Text("\nDescription: " + runWorkout!.description),
                  Text("Time spent: " + runWorkout!.duration),
                  Text("Distance: " + runWorkout!.distance),
                  Text("\nDate: " + runWorkout!.date),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getName(String uid) async {
    var result = await databaseService.getUser(uid);
    if (mounted){
      setState(() {
        name = result.getName();
      });
    }
  }
}
