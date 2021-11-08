import 'dart:ui';

import 'package:flutter/material.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                    MaterialPageRoute(builder: (context) => const NewWorkout()),
                  )
                },
                child: const Text('New workout'),
              ),
            ]
        ),
      )
    );
  }
}


class NewWorkout extends StatefulWidget {
  const NewWorkout({Key? key}) : super(key: key);

  @override
  _NewWorkoutState createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkout> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(_auth),
      body: Text("potato"),
    );
  }
}


