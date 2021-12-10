import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/screens/home/my_page/workout_details/run_details.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'dart:math';

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
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 1,
          padding: EdgeInsets.all(6),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Text(name, style: tileName),
                    Text(runWorkout!.title, style: tileTitle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(runWorkout!.duration, style: TextStyle()),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(runWorkout!.distance, style: TextStyle()),
                      ],
                    ),
                    Text(timePerKm(runWorkout!).toString()),
                    Text("\n\n"),
                    Text(runWorkout!.date, style: tileDate),
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

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  //minutt + sekund, per kilometer
  //05:20 per
  // SECONDS PER KM
  double timePerKm(RunWorkout runWorkout){
    Duration duration = parseDuration(runWorkout.duration);

    int persecond = duration.inSeconds;

    double kms = 0.0;
    if (persecond!=0) {
      kms = persecond/double.parse(runWorkout.distance);
    }
    return kms;
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
