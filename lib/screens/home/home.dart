import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/screens/home/home_tab/workout_list.dart';
import 'package:workout_app/screens/home/my_page/tab_bar_top.dart';
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

  DatabaseService? databaseService = DatabaseService();

  List<RunWorkout> runWorkouts = [];
  MapController? mapController;
  double longitude = 6.235902420311039;
  double latitude = 62.472207764237886;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
    fetchRunWorkouts();
  }

  Future fetchRunWorkouts() async {
    var result = await databaseService!.getRunsData();
      setState(() {
        runWorkouts = result;
      });
  }



  @override
  Widget build(BuildContext context) {
    //NB: fjernet const under her for det skapte trøbbel med 'column'. La også til const bak "TEXT".
    final List<Widget> _widgetOptions = <Widget>[
      // runListView(context),
      HomeWorkoutList(runWorkouts: runWorkouts),
      newWorkoutWidget(context),
      myPageTabBar()
    ];


    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: appbar(_auth, "Home"),
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
