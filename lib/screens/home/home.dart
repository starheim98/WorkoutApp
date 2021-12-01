import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/running/run_workout.dart';
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

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

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
      runListView(context),
      newWorkoutFragment(context),
      DefaultTabController(
        length: 3,
        child: Column(children: <Widget>[
          TabBar(
            labelColor: Colors.amber[800],
            unselectedLabelColor: Colors.grey[800],
            labelStyle: TextStyle(fontSize: 18),
            tabs: const [
              Tab(
                text: "Workouts",
              ),
              Tab(text: "Progression"),
              Tab(text: "Friends"),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                MyWorkouts(),
                Progression(),
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

  List<LatLng> getPoints(RunWorkout runWorkout)  {
    try {
      List<LatLng> points = <LatLng>[];
      for (GeoPoint geopoint in runWorkout.geopoints){
        points.add(LatLng(geopoint.latitude, geopoint.longitude));
      }
      return points;
    } on Exception catch (e) {
      return []; //If there is no run connected to the data there will be no data to draw.
    }
  }

SingleChildScrollView runListView(context) => SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: runWorkouts.length,
            itemBuilder: (BuildContext context, int index) {
              return runTile(runWorkouts[index], LatLng(latitude, longitude), mapController, getPoints(runWorkouts[index]));
            },
          )
        ],
      ),
    );
}


runTile(RunWorkout runWorkout, LatLng latLng, MapController? mapController, List<LatLng> points) => Card (
    child: ListTile(
      title: Text(runWorkout.title),
      subtitle: Text("Desc: " + runWorkout.description +
          ". Duration: " + runWorkout.duration + ". Distance: "
          + runWorkout.distance),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: FlutterMap(
          options: MapOptions(
            center: latLng,
            zoom: 15.0,
          ),
          mapController: mapController,
          layers: [
            tileLayerOptions,
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: latLng,
                  builder: (ctx) => const Icon(Icons.pin_drop),
                ),
              ],
            ),
            PolylineLayerOptions(
              polylines: [
                Polyline(
                    points: points,
                    strokeWidth: 4.0,
                    color: Colors.purple),
              ],
            ),
          ],
        ),
      ),
    )
);

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
////
