import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import '../../../top_secret.dart';

class RunData extends StatefulWidget {
  final double distance;
  final Duration duration;
  final List<LatLng> points;

  RunData({required this.distance, required this.duration, required this.points});

  @override
  _RunDataState createState() => _RunDataState();
}

class _RunDataState extends State<RunData> {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final AuthService _auth = AuthService();

  String title = "";
  String desc = "";

  var sizedbox = SizedBox(height: 30);
  var document;

  List<GeoPoint> latlngToGeopoint(List<LatLng> initialPoints){
    initialPoints = widget.points;
    List<GeoPoint> geopoints = <GeoPoint>[]; // List Literal
    for (LatLng latLng in initialPoints){
      geopoints.add(GeoPoint(latLng.latitude, latLng.longitude));
    }
    return geopoints;
  }
  @override
  void initState() {
    if(widget.points.isEmpty){
      widget.points.add(LatLng(62.4693179, 6.2419502));
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String sDuration =
        "${widget.duration.inHours.toString().padLeft(2, '0')}:"
        "${widget.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
        "${(widget.duration.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
    return Scaffold(
        appBar: appbar(_auth, "Save your run", context),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                sizedbox,
                SizedBox(
                  width: 350,
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Title your run!"),
                    validator: (val)=> val!.isEmpty ? 'Title...' : null,
                    onChanged: (val) {
                      setState(() => title = val);
                    },
                  )
                ),
              SizedBox(
                  width: 350,
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Provide a short description of your run!"),
                    validator: (val)=> val!.isEmpty ? 'Description...' : null,
                    onChanged: (val) {
                      setState(() => desc = val);
                    },
                  )
              ),
                sizedbox,
                Text("Distance: " + widget.distance.toString() + " km"),
                sizedbox,
                Text("Duration: " + sDuration ),
                sizedbox,
                const Text("This is a sample photo. Your run will show after save.", style: TextStyle(fontStyle: FontStyle.italic)
                ),
                SizedBox(
                    height: 240,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(widget.points.last.latitude, widget.points.last.longitude),
                        zoom: 15.0,
                      ),
                      layers: [
                        tileLayerOptions,
                        PolylineLayerOptions(
                          polylines: [
                            Polyline(
                                points: widget.points,
                                strokeWidth: 4.0,
                                color: Colors.purple),
                          ],
                        ),
                      ],
                    ),
                ),
                ElevatedButton(
                  onPressed: ()  => {
                        DatabaseService().saveRun(title, desc, sDuration, widget.distance, latlngToGeopoint(widget.points)),
                        Navigator.of(context).popUntil((route) => route.isFirst),
                      },
                  child: const Text("Save Run"),
                ),
          ])),
        ));
   }
}

