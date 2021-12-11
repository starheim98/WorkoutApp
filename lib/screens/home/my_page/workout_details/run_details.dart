import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: Colors.brown[50],
        appBar: appbar(_auth, runWorkout!.title, context),
        body: Card(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                   child: Column(
                children: [
                  Text(
                     runWorkout!.title,
                    style: textStyle,
                  ),
                  Text(
                    formattedDate(runWorkout!.date),
                    style: tileDate.copyWith(fontSize: 15),
                  ),
                  sizedBox,
                   Text(
                     runWorkout!.description + "I wne tfor a long run today it was so nice to run i nthe frtehs swewet ait i loved it ."
                         "I wne tfor a long run today it was so nice to run i nthe frtehs swewet ait i loved it ."
                         "I wne tfor a long run today it was so nice to run i nthe frtehs swewet ait i loved it ."
                         "I wne tfor a long run today it was so nice to run i nthe frtehs swewet ait i loved it ."
                         "",
                    style: tileTitle.copyWith(fontWeight: FontWeight.normal),
                     maxLines: 5,
                  ),
                  sizedBox,
                   Text(
                      "Duration",
                    style: textStyle,
                  ),
                  Text(runWorkout!.duration, style: numberStyle.copyWith(fontSize: 20),),
                  sizedBox,
                   Text(
                      "Distance",
                    style: textStyle,
                  ),
                  Text(runWorkout!.distance + " km", style: numberStyle.copyWith(fontSize: 20)),
                  sizedBox,
              ],
            ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
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
                                points: runWorkout!.getPoints(), strokeWidth: 4.0, color: Colors.purple),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
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
