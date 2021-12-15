import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/screens/home/my_page/workout_details/run_details.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/shared/km_per_minute_parser.dart';

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
      elevation: 3,

      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RunWorkoutDetailsPage(runWorkout: runWorkout!)),
          )
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 1,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: tileName),
                    Text(runWorkout!.title, style: tileTitle),
                    Text((runWorkout!.getDate()), style: numberStyle),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      width: MediaQuery.of(context).size.width *0.22,
                      child: Text(runWorkout!.duration, style: numberStyle),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      width: MediaQuery.of(context).size.width *0.22,
                      child: Text(runWorkout!.distance + " km",
                          style: numberStyle),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      width: MediaQuery.of(context).size.width *0.22,
                      child: Text(timePerKm(runWorkout!).toString() + "/km",
                          style: numberStyle),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.43,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(runWorkout!.getPoints().last.latitude,
                        runWorkout!.getPoints().last.longitude),
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
            ],
          ),
        ),
      ),
    );
  }

  Future getName(String uid) async {
    var result = await databaseService.getUser(uid);
    if (mounted) {
      setState(() {
        name = result.getName();
      });
    }
  }
}
