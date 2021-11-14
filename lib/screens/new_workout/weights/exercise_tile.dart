
import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/new_workout/weights/set_list.dart';

class ExerciseTile extends StatefulWidget {
  Exercise exercise;
  ExerciseTile({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.exercise.getName(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
            ),
          ),
          SetList(exercise: widget.exercise),
          ElevatedButton(
            onPressed: () => addSet(),
            child: Text("Add set"),
          ),
          const Divider(
            color: Colors.black,
            thickness: 2,
          )
        ]
    );
  }

  addSet() {
    setState(() {
      widget.exercise.addSet();
    });
  }
}