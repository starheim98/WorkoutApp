import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/screens/home/my_page/workout_details/run_details.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:intl/intl.dart';

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
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: tileName),
                    Text(runWorkout!.title, style: tileTitle),
                    Text(formattedDate(runWorkout!.date), style: tileDate),
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

  String formattedDate(String now) {
    DateTime haha = DateTime.parse(now);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(haha);
    return formatted;
  }

  //Kilometer per minute code////////////////////////
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

  String timePerKm(RunWorkout runWorkout) {
    var formatting = Duration(hours: 0, minutes: 0, seconds: 0);
    if (runWorkout.distance != "0" || runWorkout.distance != null) {
      Duration duration = parseDuration(runWorkout.duration);
      int inseconds = duration.inSeconds;
      double secondsPerKm = 0.0;
      if (inseconds != 0) {
        secondsPerKm = inseconds / double.parse(runWorkout.distance);
        formatting = parseDuration(secondsPerKm.toString());
      }
      return _printDuration(formatting);
    } else {
      return _printDuration(formatting);
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
