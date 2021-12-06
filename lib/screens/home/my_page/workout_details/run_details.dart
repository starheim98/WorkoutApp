import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';


class RunWorkoutDetailsPage extends StatefulWidget {
  RunWorkout runWorkout;
  RunWorkoutDetailsPage({Key? key, required this.runWorkout}) : super(key: key);

  @override
  _RunWorkoutDetailsPageState createState() => _RunWorkoutDetailsPageState();
}

class _RunWorkoutDetailsPageState extends State<RunWorkoutDetailsPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    SizedBox sizedBox = SizedBox(height: 12, width: MediaQuery.of(context).size.width);
    return Scaffold(
      appBar: appbar(_auth, widget.runWorkout.title, context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Title",
              style: textStyle,
            ),
            Text(widget.runWorkout.title),
            sizedBox,
            const Text(
                "Description",
              style: textStyle,

            ),
            Text(widget.runWorkout.description),
            sizedBox,
            const Text(
                "Duration",
              style: textStyle,

            ),
            Text(widget.runWorkout.duration),
            sizedBox,
            const Text(
                "Distance",
              style: textStyle,
            ),
            Text(widget.runWorkout.distance + " km"),
            sizedBox,
          ],
        ),
      )
    );
  }
}
