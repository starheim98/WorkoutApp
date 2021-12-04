
import 'package:flutter/material.dart';
import 'package:workout_app/screens/new_workout/choose_new_or_template.dart';
import 'package:workout_app/screens/new_workout/running/running_screen.dart';

Column newWorkoutWidget(BuildContext context) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text("Select form of training:"),
        const SizedBox(height: 50.0),
        ElevatedButton(
            onPressed: () async => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Running()),
              )
            },
            child:
            const Text("Running", style: TextStyle(color: Colors.white))),
        ElevatedButton(
            onPressed: () async => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WeightLifting()),
              )
            },
            child: const Text("Weightlifting",
                style: TextStyle(color: Colors.white))),
      ],
    );