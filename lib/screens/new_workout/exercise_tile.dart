import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';

class ExerciseTile extends StatefulWidget {
  //const ExerciseTile({Key? key}) : super(key: key);
  final Exercise exercise;
  final int index;
  const ExerciseTile({required this.exercise, required this.index});

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(exercise.name),
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("SET " + (index+1).toString() +":"),
            const Flexible(
              child: TextField(
                  decoration: InputDecoration(
                      hintText: "repetitions",
                      contentPadding: EdgeInsets.all(10)
                  )
              ),
            ),
            const Flexible(
              child: TextField(
                  decoration: InputDecoration(
                      hintText: "weight",
                      contentPadding: EdgeInsets.all(10)
                  )
              ),
            ),
            IconButton(
                onPressed: () => exercises.removeAt(index),
                icon: const Icon(Icons.close))
          ],
        )
      ]
    );
  }
}


/*Text text = Text(exercise.name);*/
/*
Row row(index) => Row(
  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: <Widget>[
  Text("SET " + (index+1).toString() +":"),
  const Flexible(
  child: TextField(
  decoration: InputDecoration(
  hintText: "repetitions",
  contentPadding: EdgeInsets.all(10)
  )
  ),
  ),
  const Flexible(
  child: TextField(
  decoration: InputDecoration(
  hintText: "weight",
  contentPadding: EdgeInsets.all(10)
  )
  ),
  ),
  IconButton(
  onPressed: () => exercises.removeAt(index),
  icon: const Icon(Icons.close))
  ],
);*/
