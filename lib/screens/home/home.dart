import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';

import 'package:workout_app/screens/new_workout/choose_new_or_template.dart';
import 'package:workout_app/screens/new_workout/running/running_screen.dart';


///FLUTTER MAP STUFF
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapstool;
import 'package:workout_app/screens/new_workout/running/running_save_run.dart';
///
import 'package:cloud_firestore/cloud_firestore.dart';

///

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  @override
  Widget build(BuildContext context) {
    //NB: fjernet const under her for det skapte trøbbel med 'column'. La også til const bak "TEXT".
     final List<Widget> _widgetOptions = <Widget>[
      hometest(context),

      column(context),

      const Text(
        'MY PAGE',
        style: optionStyle,
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
}

/////////////////////////////////
final FirebaseDatabase database = FirebaseDatabase.getInstance();
DatabaseReference ref = database.reference("server/saving-data/fireblog/posts");

MapController? mapController;
List<LatLng> getPoints(){
  var points = <LatLng>[];


  return points;
}

Column hometest(context) => Column(
  children: [
    FlutterMap(
      options: MapOptions(
        center: LatLng(latitude, longitude),
        zoom: 15.0,
      ),
      mapController: mapController,
      layers: [
        TileLayerOptions(

        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(latitude, longitude),
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
  ],
);
/////////////////////////////////

/// New Workout/Record screen.
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
////