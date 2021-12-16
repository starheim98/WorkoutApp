import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/screens/home/my_page/workout_details/run_details.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
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
      margin: const EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9),
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 1,
          child: Row(
            children: [
              Expanded(
                flex: 50,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              'lib/assets/run.png',
                              height: 40,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: tileName),
                                GradientText(runWorkout!.title,
                                    gradientDirection: GradientDirection.btt,
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 14.0 + 2,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    colors: const [
                                      Color(0xFFC9082B),
                                      Color(0xFF6C0A39),
                                    ]),
                                Text((runWorkout!.getDate()),
                                    style: numberStyle.copyWith(height: 1.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
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
                            width: 15,
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
                            width: 15,
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
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 33,
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
