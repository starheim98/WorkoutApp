import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/shared/select_exercise.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:workout_app/shared/dialogues.dart';

import 'exercise_list.dart';



class NewWorkout extends StatefulWidget {
  const NewWorkout({Key? key}) : super(key: key);

  @override
  _NewWorkoutState createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  final AuthService _authService = AuthService();
  WeightWorkout weightWorkout = WeightWorkout();

  @override
  void initState() {
    weightWorkout.setName("Workout " + weightWorkout.date!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbar(_authService, "NEW WORKOUT", context),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
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
                onPressed: () async{
                  var result = await Dialogues().confirmDialogue(
                      context, "Finished?", "Do you want to finish your workout?");
                  if (result) {
                    finishWorkout();
                  }
                },
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
            Exercise exercise = Exercise(value);
            exercise.addSet();
            exercise.addSet();
            exercise.addSet();
            weightWorkout.addExercise(exercise);
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
    DatabaseService().addWeightWorkout(weightWorkout);
    Navigator.pop(this.context);
    Navigator.pop(this.context);
  }
}
