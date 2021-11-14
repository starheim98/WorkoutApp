import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/new_workout/weights/select_exercise.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';

import 'exercise_list.dart';

class WeightLifting extends StatefulWidget {
  const WeightLifting({Key? key}) : super(key: key);

  @override
  State<WeightLifting> createState() => _WeightLiftingState();
}

class _WeightLiftingState extends State<WeightLifting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Weightlifting"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to first route when tapped.
                  },
                  child: const Text('Select from template'),
                ),
                ElevatedButton(
                  onPressed: () async => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewWorkout()),
                    )
                  },
                  child: const Text('New workout'),
                ),
              ]),
        ));
  }
}

// TODO: own class file
class NewWorkout extends StatefulWidget {
  const NewWorkout({Key? key}) : super(key: key);

  @override
  _NewWorkoutState createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  final AuthService _auth = AuthService();
  WeightWorkout weightWorkout = WeightWorkout();


  @override
  void initState() {
    weightWorkout.setName("Workout " + weightWorkout.getDate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: appbar(_auth, "NEW WORKOUT"),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(weightWorkout.name!),
                const Icon(Icons.create_outlined),
              ],
            ),
            ExerciseList(workout: weightWorkout),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () => setState(() => newExercise(context)),
                child: Text("Add exercise")),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () => finishWorkout(),
                child: Text("Finish"),
              ),
            )
          ]),
        ));
  }

  void newExercise(BuildContext context) {
    Future<String> future = selectExercise(context);
    future.then((value) => {
          setState(() {
            weightWorkout.addExercise(Exercise(value));
          })
        });
  }

  Future<String> selectExercise(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SelectExercise()));
    return await result;
  }

  finishWorkout() {
    weightWorkout.finishWorkout();
    Navigator.pop(this.context);
    Navigator.pop(this.context);
  }
}
