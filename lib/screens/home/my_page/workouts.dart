import 'package:flutter/material.dart';

class MyWorkouts extends StatefulWidget {
  const MyWorkouts({Key? key}) : super(key: key);

  @override
  _MyWorkoutsState createState() => _MyWorkoutsState();
}

class _MyWorkoutsState extends State<MyWorkouts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text("Workouts", style: TextStyle(fontSize: 25,)),
        ),
      ],
    );
  }
}
