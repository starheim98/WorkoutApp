import 'package:flutter/material.dart';
import 'package:workout_app/screens/home/home.dart';
import 'package:workout_app/screens/new_workout/choose_new_or_template.dart';
import 'package:workout_app/screens/new_workout/running/running_screen.dart';
import 'package:workout_app/screens/new_workout/weights/weightlift_screen.dart';
import 'package:workout_app/services/auth.dart';


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


//TODO: MOVE TO PROPER CLASS THESE ARE NOT CONSTANTS
Column column23132(context) => Column(
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
     const Text("Running", style: TextStyle(color: Colors.white))
    ),
    ElevatedButton(
        onPressed: () async => {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeightLifting()),
            )
        },
        child: const Text("Weightlifting",
    style: TextStyle(color: Colors.white))),
    ],
);
*/


/// AppBar - TODO: Move to better named file? or not
appbar(AuthService _auth, String title) => AppBar(
      title: Text(title),
      backgroundColor: Colors.brown[400],
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