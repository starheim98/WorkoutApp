
import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';

class ExerciseTile extends StatelessWidget {
  late final Exercise exercise;

  ExerciseTile({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Column(
      //     children: <Widget>[
      //       Text(exercise.name),
      //       Row(
      //           children: <Widget>[
      //             Text("SET " + (1).toString() + ":"),
      //             const Flexible(
      //               child: TextField(
      //                   decoration: InputDecoration(
      //                       hintText: "repetitions",
      //                       contentPadding: EdgeInsets.all(10))),
      //             ),
      //             const Flexible(
      //               child: TextField(
      //                   decoration: InputDecoration(
      //                       hintText: "weight", contentPadding: EdgeInsets.all(10))),
      //             ),
      //             IconButton(
      //                 onPressed: () => print("123"), icon: const Icon(Icons.close))
      //           ],
      //         ),
      //     ]
      // )
      child: Text(exercise.getName()),
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
