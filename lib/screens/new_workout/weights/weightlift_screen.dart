import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/new_workout/weights/save_workout.dart';
import 'package:workout_app/shared/select_exercise.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:workout_app/shared/dialogues.dart';

import 'exercise_list.dart';

class NewWorkout extends StatefulWidget {
  WeightWorkout? workout;
  
  NewWorkout({Key? key}) : super(key: key);
  NewWorkout.template({Key? key, required this.workout}) : super(key: key);

  @override
  _NewWorkoutState createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  WeightWorkout? weightWorkout;

  @override
  void initState() {
    if(widget.workout == null){
      weightWorkout = WeightWorkout();
    } else {
      weightWorkout = widget.workout!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () => finishWorkout(context),
              child: const Text('Finish'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(children: <Widget>[
            ExerciseList(workout: weightWorkout!),
            const SizedBox(height: 50),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.7,
            //   child: ElevatedButton(
            //       onPressed: () => setState(() => newExercise(context)),
            //       child: const Text("Add exercise")),
            // ),
            const SizedBox(height: 50),
          ]),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => setState(() => newExercise(context)),
          label: const Text("      Add exercise      "),
          backgroundColor: const Color(0xff0068C8),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }

  void newExercise(BuildContext context) {
    Future<String> future = selectExercise(context);
    future.then((value) => addExercise(value));
  }

  void addExercise(String exericse) {
    setState(() {
      Exercise exercise = Exercise(exericse);
      exercise.addSet();
      exercise.addSet();
      exercise.addSet();
      weightWorkout!.addExercise(exercise);
    });
  }

  Future<String> selectExercise(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SelectExercise()));
    return await result;
  }

  finishWorkout(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SaveWeightWorkout(
                  workout: weightWorkout!,
                )));
  }
}
