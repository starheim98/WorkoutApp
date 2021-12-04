import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/screens/home/home_tab/workout_list.dart';
import 'package:workout_app/screens/home/my_page/workouts.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';

import 'package:workout_app/screens/new_workout/choose_new_or_template.dart';
import 'package:workout_app/screens/new_workout/running/running_screen.dart';

import '../../top_secret.dart'; //Mathias top secret
import 'my_page/friends.dart';
import 'my_page/progression.dart';

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

  List<charts.Series<LinearGraphData, num>> setupGraphData() {
    final data = <LinearGraphData>[];
    int index = 0;

    for(RunWorkout runWorkout in runWorkouts ) {
      Duration duration = parseDuration(runWorkout.duration);
      int perminute = duration.inSeconds;
      if (perminute!=0){
        double kmh = double.parse(runWorkout.distance) / perminute;
        print("km/h:"+kmh.toString());
        index ++;
        data.add(LinearGraphData(index, kmh.round()));
      }
    }

    return [
      charts.Series<LinearGraphData, int>(
        id: 'WeightGraph',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearGraphData sales, _) => sales.week,
        measureFn: (LinearGraphData sales, _) => sales.weight,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    //NB: fjernet const under her for det skapte trøbbel med 'column'. La også til const bak "TEXT".
    final List<Widget> _widgetOptions = <Widget>[
      // runListView(context),
      HomeWorkoutList(runWorkouts: runWorkouts),
      newWorkoutFragment(context),
      DefaultTabController(
        length: 3,
        child: Column(children: <Widget>[
          TabBar(
            labelColor: Colors.amber[800],
            unselectedLabelColor: Colors.grey[800],
            labelStyle: TextStyle(fontSize: 18),
            tabs: const [
              Tab(text: "Workouts",),
              Tab(text: "Progression"),
              Tab(text: "Friends"),
            ],
          ),
           Expanded(
            child: TabBarView(
              children: <Widget>[
                MyWorkouts(),
                Progression(setupGraphData()),
                Friends(),
              ],
            ),
          )
        ]),
      ),
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

  /// New Workout/Record screen.
  Column newWorkoutFragment(context) => Column(
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
}


////

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}