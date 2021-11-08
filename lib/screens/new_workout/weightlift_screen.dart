
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/new_workout/exercise_list.dart';
import 'package:workout_app/screens/new_workout/exercise_tile.dart';
import 'package:workout_app/screens/new_workout/select_exercise.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';

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
                  onPressed: () async =>
                  {
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

class NewWorkout extends StatefulWidget {
  const NewWorkout({Key? key}) : super(key: key);

  @override
  _NewWorkoutState createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  final AuthService _auth = AuthService();
  WeightWorkout weightWorkout = WeightWorkout();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: appbar(_auth, "NEW WORKOUT"),
        body: Column(
            children: <Widget>[
              ExerciseList(workout: weightWorkout),
              ElevatedButton(onPressed: () => setState(() => newExercise(context)) , child: Text("Add exercise"))
            ]
        )
    );
  }

  void newExercise(BuildContext context) {
    Future<String> future = selectExercise(context);
    future.then((value) => {
      weightWorkout.addExercise(Exercise(value)),
    });
  }

  Future<String> selectExercise(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectExercise())
    );
    return await result;
  }
}



Column testingMachine(index, exercise) =>
    Column(children: <Widget>[
      Text(exercise.name),
      Row(
        children: <Widget>[
          Text("SET " + (index + 1).toString() + ":"),
          const Flexible(
            child: TextField(
                decoration: InputDecoration(
                    hintText: "repetitions",
                    contentPadding: EdgeInsets.all(10))),
          ),
          const Flexible(
            child: TextField(
                decoration: InputDecoration(
                    hintText: "weight", contentPadding: EdgeInsets.all(10))),
          ),
          IconButton(
              onPressed: () => print("123"), icon: const Icon(Icons.close))
        ],
      ),
      Row(
        children: <Widget>[
          Text("SET " + (index + 1).toString() + ":"),
          const Flexible(
            child: TextField(
                decoration: InputDecoration(
                    hintText: "repetitions",
                    contentPadding: EdgeInsets.all(10))),
          ),
          const Flexible(
            child: TextField(
                decoration: InputDecoration(
                    hintText: "weight", contentPadding: EdgeInsets.all(10))),
          ),
          IconButton(
              onPressed: () => print("123"), icon: const Icon(Icons.close))
        ],
      ),
    ]);
