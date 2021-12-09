import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';

import '../../../../top_secret.dart';


class RunWorkoutDetailsPage extends StatefulWidget {
  RunWorkout runWorkout;
  RunWorkoutDetailsPage({Key? key, required this.runWorkout}) : super(key: key);

  @override
  _RunWorkoutDetailsPageState createState() => _RunWorkoutDetailsPageState();
}

class _RunWorkoutDetailsPageState extends State<RunWorkoutDetailsPage> {
  final AuthService _auth = AuthService();
  RunWorkout? runWorkout;

  @override
  void initState() {
    runWorkout = widget.runWorkout;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizedBox sizedBox = SizedBox(height: 12, width: MediaQuery.of(context).size.width);

    return  Scaffold(
        appBar: appbar(_auth, runWorkout!.title, context),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Title",
                style: textStyle,
              ),
              Text(runWorkout!.title),
              sizedBox,
              const Text(
                  "Description",
                style: textStyle,

              ),
              Text(runWorkout!.description),
              sizedBox,
              const Text(
                  "Duration",
                style: textStyle,

              ),
              Text(runWorkout!.duration),
              sizedBox,
              const Text(
                  "Distance",
                style: textStyle,
              ),
              Text(runWorkout!.distance + " km"),
              sizedBox,
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(runWorkout!.getPoints().last.latitude, runWorkout!.getPoints().last.longitude),
                    zoom: 13.0,
                  ),
                  layers: [
                    tileLayerOptions,
                    PolylineLayerOptions(
                      polylines: [
                        Polyline(
                            points: runWorkout!.getPoints(), strokeWidth: 4.0, color: Colors.purple),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
