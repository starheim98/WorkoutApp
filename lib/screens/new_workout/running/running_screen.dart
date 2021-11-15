import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

/// https://github.com/Baseflow/flutter-geolocator/blob/master/geolocator_android/example/lib/main.dart GEOLOCATOR EXAMPLE
/// https://pub.dev/packages/geolocator/example - ^
/// https://github.com/fleaflet/flutter_map/blob/master/example/lib/pages/map_controller.dart CONTROLLER EXAMPLE
class Running extends StatefulWidget {
  @override
  State<Running> createState() => _RunningState();
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy
          .high); //LocationAccuracy.high: 0-100m for android, 10m for iOS.
}

class _RunningState extends State<Running> {
  bool positionStreamStarted = false;
  MapController? mapController;
  StreamSubscription<Position>? _positionStreamSubscription;
  final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  final List<Position> _positionItems = <Position>[];

  Position? position;
  double longitude = 6.235902420311039;
  double latitude = 62.472207764237886;
  var points = <LatLng>[];
  var pointsGradient = <LatLng>[];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  void refreshToCurrentPosition() {
    _determinePosition().then((value) => position = value);
    if (position?.longitude != null) {
      setState(() {
        // USE SET STATE
        longitude = position!.longitude;
      });
    }
    if (position?.latitude != null) {
      setState(() {
        latitude = position!.latitude;
      });
    }
    mapController?.move(LatLng(latitude, longitude), 17);
  }

  void updatePoints() {
    for (Position position in _positionItems){
      LatLng latLng = LatLng(position.latitude, position.longitude);
      if(!points.contains(latLng)){ //Without this, it will add previous positions.
        points.add(latLng);
      }
    }
  }

  void clearPoints(){
    _positionItems.clear();
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _updatePositionList(Position position) {
    _positionItems.add(position);
    setState(() {});
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = geolocatorPlatform.getPositionStream(
          desiredAccuracy: LocationAccuracy.best);
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => {
        _updatePositionList(position),
        refreshToCurrentPosition(),
        updatePoints(),
      });
      _positionStreamSubscription?.pause();
    }
    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }
      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 10,
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Running"),
        ),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(latitude, longitude),
            zoom: 15.0,
          ),
          mapController: mapController,
          layers: [
            TileLayerOptions(
              //Map box data for tile layer.

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
        floatingActionButton: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: Icon(Icons.location_searching),
                heroTag: "btn1",
                onPressed: () {
                  clearPoints();
                },
              ),
              sizedBox,
              FloatingActionButton(
                child: (_positionStreamSubscription == null ||
                    _positionStreamSubscription!.isPaused)
                    ? const Icon(Icons.play_arrow)
                    : const Icon(Icons.pause),
                onPressed: () {
                  positionStreamStarted = !positionStreamStarted;
                  _toggleListening();
                },
                tooltip: (_positionStreamSubscription == null)
                    ? 'Start position updates'
                    : _positionStreamSubscription!.isPaused
                    ? 'Resume'
                    : 'Pause',
                backgroundColor: _determineButtonColor(),
              ),
            ]));
  }
}