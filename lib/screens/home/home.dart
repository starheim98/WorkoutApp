import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/home/home_tab/hometab.dart';
import 'package:workout_app/screens/home/my_page/my_page.dart';
import 'package:workout_app/screens/home/my_page/workouts.dart';
import 'package:workout_app/screens/home/new_workout_tab/new_workout_screen.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';

import '../../top_secret.dart'; //Mathias top secret


import 'dart:async';

import '../../../top_secret.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;

  DatabaseService? databaseService;

  List<RunWorkout> runWorkouts = [];
  List<WeightWorkout> weightWorkouts = [];
  var friendsWorkouts = [];

  void _onItemTapped(int index) {
    setState(() => {
      _selectedIndex= index,
      fetchData(),
    });
  }

  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
    fetchData();
  }

  Future fetchData() async {
    var runsData = await databaseService!.getRunsData();
    var weightWorkoutData = await databaseService!.getWeightWorkouts();
    var friendsWO = await databaseService!.getFriendsWorkouts();
    if(mounted) {
      setState(() {
        runWorkouts = runsData;
        weightWorkouts = weightWorkoutData;
        friendsWorkouts = friendsWO;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //NB: fjernet const under her for det skapte trøbbel med 'column'. La også til const bak "TEXT".
    final List<Widget> _widgetOptions = <Widget>[
      // runListView(context),
      HomeTab(runWorkouts: runWorkouts, weightWorkouts: weightWorkouts, friendsWorkouts: friendsWorkouts),
      newWorkoutTab(context),
      myPageTab()
    ];

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: appbar(_auth, "Home", context),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_manual_record_rounded),
            label: 'New Workout/Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Page',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
