import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/home/home.dart';
import 'package:workout_app/screens/new_workout/choose_new_or_template.dart';
import 'package:workout_app/screens/new_workout/running/running_screen.dart';
import 'package:workout_app/screens/new_workout/weights/weightlift_screen.dart';
import 'package:workout_app/services/auth.dart';

import '../top_secret.dart';


const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0)
    )
);


const textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
);

/// AppBar - TODO: Move to better named file? or not
appbar(AuthService _auth, String title) => AppBar(
  title: Text(title),
  backgroundColor: Colors.red[400], //DEN VAR brown[400]
  elevation: 0.0, //no dropshadow / flat on the screen
  actions: <Widget>[
    TextButton.icon(
      onPressed: () async {
        await _auth.signOut();
      },
      label: const Text("Logout"),
      icon: const Icon(Icons.person),
    ),
  ],
);


