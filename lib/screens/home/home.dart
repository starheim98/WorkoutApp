import 'package:flutter/material.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/home/home_tab/hometab.dart';
import 'package:workout_app/screens/home/my_page/my_page.dart';
import 'package:workout_app/screens/home/new_workout_tab/new_workout_screen.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';

import 'dart:async';


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
  bool loading = true;

  String firstName = "";

  void _onItemTapped(int index) {
    setState(() => {
          _selectedIndex = index,
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
    var user = await databaseService!.getThisUser();
    if (mounted) {
      setState(() {
        firstName = user.firstName;
        runWorkouts = runsData;
        weightWorkouts = weightWorkoutData;
        friendsWorkouts = friendsWO;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomeTab(
          runWorkouts: runWorkouts,
          weightWorkouts: weightWorkouts,
          friendsWorkouts: friendsWorkouts,
          loading: loading,
      ),
      newWorkoutTab(context),
      myPageTab()
    ];

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: appbar(_auth, firstName, context),
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
