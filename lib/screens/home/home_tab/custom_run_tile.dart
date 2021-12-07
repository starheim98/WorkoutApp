import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';
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
  String name = "";

  @override
  void initState() {
    getName(widget.runWorkout.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                          points: widget.runWorkout.getPoints(),
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
                Text("Title: " + widget.runWorkout.title),
                Text("\nDescription: " + widget.runWorkout.description),
                Text("Time spent: " + widget.runWorkout.duration),
                Text("Distance: " + widget.runWorkout.distance),
                Text("\nDate: " + widget.runWorkout.date),
              ],
            )
          ],
        ),
      ),
    );;
  }

  Future getName(String uid) async {
    var result = await databaseService.getUser(uid);
    setState(() {
      name = result.getName();
    });
  }
}
