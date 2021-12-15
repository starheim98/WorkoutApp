import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/shared/constants.dart';

class WorkoutDetailPage extends StatefulWidget {
  WeightWorkout workout;

  WorkoutDetailPage({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  @override
  Widget build(BuildContext context) {
    SizedBox sizedBox =
        SizedBox(height: 12, width: MediaQuery.of(context).size.width);
    List<Exercise> exercises = widget.workout.exercises;
    for (Exercise exercise in exercises) {
      exercise.name;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.workout.name!),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GradientText(
                    widget.workout.name!,
                    style: const TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16.0 + 2,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: const [
                      Color(0xFF4574EB),
                      Color(0xFF005FB7),
                    ]
                ),
                Text(widget.workout.name!),
                sizedBox,
                const Text(
                  "Exercises",
                  style: detailsName,
                ),
                ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: exercises.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(child: Text(exercises[index].name)); // Ditta e for sentrere den
                    }),
                sizedBox,
                const Text(
                  "Duration",
                  style: numberStyle,
                ),
                Text(widget.workout.getDuration()),
                sizedBox,
                const Text(
                  "Date:",
                  style: numberStyle,
                ),
                Text(widget.workout.getDate()!),
                sizedBox,
              ],
            ),
          ),
        ));
  }
}
