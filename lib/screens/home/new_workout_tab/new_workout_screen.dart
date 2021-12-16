import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workout_app/screens/new_workout/choose_new_or_template.dart';
import 'package:workout_app/screens/new_workout/running/running_screen.dart';

Column newWorkoutTab(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "Select training",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeightLifting()),
            )
          },
          child: Container(
            height: 120,
            margin: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  )
                ]),
            child: Row(
              children: <Widget>[
                Expanded(child: Image.asset('lib/assets/weight.png'), flex: 4),
                const Expanded(
                  child: Text(
                    "Weightlifting",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff005FB7)),
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: () async => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Running()),
            )
          },
          child: Container(
            height: 120,
            margin: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  )
                ]),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Image.asset('lib/assets/run.png'),
                  flex: 4,
                ),
                // Expanded(child: Icon(Icons.fitness_center), flex: 4,),
                const Expanded(
                  child: Text(
                    "Running",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffC9082B)),
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
