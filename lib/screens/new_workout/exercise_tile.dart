
import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/screens/new_workout/set_list.dart';

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
          Text(widget.exercise.getName()),
          SetList(exercise: widget.exercise),
          ElevatedButton(
            onPressed: () => addSet(),
            child: Text("Add set"),

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