import 'package:flutter/material.dart';
import 'package:workout_app/screens/home/home.dart';


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


//TODO: MOVE TO PROPER CLASS
Column column(context) => Column(
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
                MaterialPageRoute(builder: (context) => WeightLifting()),
            )
        },
        child: const Text("Weightlifting",
    style: TextStyle(color: Colors.white))),
    ],
);