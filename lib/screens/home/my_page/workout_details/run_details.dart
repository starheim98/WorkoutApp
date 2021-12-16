import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:workout_app/shared/km_per_minute_parser.dart';

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
  DatabaseService? databaseService;
  String firstName = "";

  @override
  void initState() {
    runWorkout = widget.runWorkout;
    databaseService = DatabaseService();
    fetchUser();
    super.initState();
  }

  Future fetchUser() async {
    var user = await databaseService!.getThisUser();
    if (mounted) {
      setState(() {
        firstName = user.firstName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizedBox sizedBox =
        SizedBox(height: 12, width: MediaQuery.of(context).size.width);
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: appbar(_auth, runWorkout!.title, context),
        body: Card(
          margin: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    firstName,
                                    style: detailsName,
                                  ),
                                  GradientText(runWorkout!.title,
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 16.0 + 2,
                                        fontWeight: FontWeight.bold,
                                        height: 1.5,
                                      ),
                                      gradientDirection: GradientDirection.btt,
                                      colors: const [
                                        Color(0xFFC9082B),
                                        Color(0xFF6C0A39),
                                      ]),
                                  Text(
                                    runWorkout!.getDate(),
                                    style: numberStyle,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: Image.asset('lib/assets/run.png', height: 40), flex: 1),
                          ],
                        ),

                      sizedBox,
                      Row(
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Duration",
                                style: durationDistanceAvgPaceText,
                              ),
                              Text(
                                runWorkout!.duration,
                                style: numberStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Column(
                            children: [
                              const Text(
                                "Distance",
                                style: durationDistanceAvgPaceText,
                              ),
                              Text(runWorkout!.distance + " km",
                                  style: numberStyle),
                            ],
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Column(
                            children: [
                              const Text(
                                "Avg. pace",
                                style: durationDistanceAvgPaceText,
                              ),
                              Text(timePerKm(runWorkout!).toString() + " /km",
                                  style: numberStyle),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        runWorkout!.description,
                        style:
                            tileTitle.copyWith(fontWeight: FontWeight.normal, fontSize: 12+2, height: 1.3),
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex:1,
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
        ));
  }
}
