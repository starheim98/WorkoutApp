import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:workout_app/shared/km_per_minute_parser.dart';

import '../../../top_secret.dart';

class RunData extends StatefulWidget {
  final double distance;
  final Duration duration;
  final List<LatLng> points;

  RunData(
      {required this.distance, required this.duration, required this.points});

  @override
  _RunDataState createState() => _RunDataState();
}

class _RunDataState extends State<RunData> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final AuthService _auth = AuthService();

  String title = "";
  String desc = "";

  var sizedbox = const SizedBox(height: 30);
  var document;

  List<GeoPoint> latlngToGeopoint(List<LatLng> initialPoints) {
    initialPoints = widget.points;
    List<GeoPoint> geopoints = <GeoPoint>[]; // List Literal
    for (LatLng latLng in initialPoints) {
      geopoints.add(GeoPoint(latLng.latitude, latLng.longitude));
    }
    return geopoints;
  }

  @override
  void initState() {
    if (widget.points.isEmpty) {
      widget.points.add(LatLng(62.4693179, 6.2419502));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String sDuration = "${widget.duration.inHours.toString().padLeft(2, '0')}:"
        "${widget.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
        "${(widget.duration.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
    return Scaffold(
        appBar: appbar(_auth, "Save your run", context),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
            DatabaseService().saveRun(title, desc, sDuration, widget.distance,
                latlngToGeopoint(widget.points)),
            Navigator.of(context).popUntil((route) => route.isFirst),
          },
          label: const Text("     Save Run     "),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: Center(
              child: Column(children: <Widget>[
            sizedbox,
            SizedBox(
                width: 350,
                child: TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: "Title your run!"),
                  validator: (val) => val!.isEmpty ? 'Title...' : null,
                  onChanged: (val) {
                    setState(() => title = val);
                  },
                )),
            SizedBox(
                width: 350,
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: "Provide a short description of your run!"),
                  validator: (val) => val!.isEmpty ? 'Description...' : null,
                  onChanged: (val) {
                    setState(() => desc = val);
                  },
                )),
            sizedbox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      "Duration",
                      style: durationDistanceAvgPaceText,
                    ),
                    Text(
                      printDuration(widget.duration),
                      style: numberStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    const Text(
                      "Distance",
                      style: durationDistanceAvgPaceText,
                    ),
                    Text(widget.distance.toString() + " km",
                        style: numberStyle),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    const Text(
                      "Avg. pace",
                      style: durationDistanceAvgPaceText,
                    ),
                    Text(
                        timePerKmWithoutRunworkout(widget.distance.toString(),
                                    widget.duration.toString())
                                .toString() +
                            " /km",
                        style: numberStyle),
                  ],
                ),
              ],
            ),
            sizedbox,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(widget.points.last.latitude,
                      widget.points.last.longitude),
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
          ])),
        ));
  }
}
