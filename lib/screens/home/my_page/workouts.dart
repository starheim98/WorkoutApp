import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';


class MyWorkouts extends StatefulWidget {
  const MyWorkouts({Key? key}) : super(key: key);

  @override
  _MyWorkoutsState createState() => _MyWorkoutsState();
}

class _MyWorkoutsState extends State<MyWorkouts> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseService? databaseService;
  List<WeightWorkout> weightWorkouts = [];
  int toggleValue = 0;


  @override
  Widget build(BuildContext context) {
    databaseService = DatabaseService();
    fetchData();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ToggleSwitch(
              initialLabelIndex: toggleValue,
              totalSwitches: 2,
              activeBgColor: const [Colors.amber],
              labels: const ["Weights", "Runs"],
              onToggle: (index) => toggleWorkout(index),
            )
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: weightWorkouts.length,
            itemBuilder: (BuildContext context, int index) {
              return workoutTile(weightWorkouts[index]);
            },
          )
        ],
      ),
    );
  }

  Future fetchData() async {
    var result = await databaseService!.getWeightWorkouts();
    if(mounted){
      setState(() {
        weightWorkouts = result;
      });
    }
  }

  void toggleWorkout(int index) {
    if(mounted){
      setState(() {
        toggleValue = index;
      });
    }

    // TODO: if index == 0 display weight, if 1 display runs
  }
}
