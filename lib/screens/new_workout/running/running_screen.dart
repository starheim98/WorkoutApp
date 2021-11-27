import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapstool;
import 'package:workout_app/screens/new_workout/running/running_save_run.dart';

/// https://github.com/Baseflow/flutter-geolocator/blob/master/geolocator_android/example/lib/main.dart GEOLOCATOR EXAMPLE
/// https://pub.dev/packages/geolocator/example - ^
/// https://github.com/fleaflet/flutter_map/blob/master/example/lib/pages/map_controller.dart CONTROLLER EXAMPLE
class Running extends StatefulWidget {
  @override
  State<Running> createState() => _RunningState();
}

/// Determine the current position of the device.
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
  final Set<Position> _positionItems = <Position>{};

  Position? position;
  double longitude = 6.235902420311039;
  double latitude = 62.472207764237886;
  var points = <LatLng>[];
  var pointsGradient = <LatLng>[];

  @override
  void initState() {
    super.initState();
    reset();
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
    for (Position position in _positionItems) {
      LatLng latLng = LatLng(position.latitude, position.longitude);
      if (!points.contains(latLng)) {
        //Without this, it will add previous positions.
        points.add(latLng);
      }
    }
  }

  void clearPoints() {
    _positionItems.clear();
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _updatePositionList(Position position) {
    if (!_positionItems.contains(position)) {
      _positionItems.add(position);
    } else {
      print("Duplicate!");
    }
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

  double distance() {
    double distance = 0.0;
    for (int i = 1; i < _positionItems.length; i++) {
      distance += mapstool.SphericalUtil.computeDistanceBetween(
          mapstool.LatLng(_positionItems.elementAt(i).latitude,
              _positionItems.elementAt(i).longitude),
          mapstool.LatLng(_positionItems.elementAt(i - 1).latitude,
              _positionItems.elementAt(i - 1).longitude));
    }
    return distance / 1000.0;
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 10,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Running"),
      ),
      body: IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(children: [
                  Container(
                    height: 300,
                    child: FlutterMap(
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
                  ),
                  Container(
                    height: 120.0,
                    child: buildTime(),
                  ),
                  sizedBox,
                  Container(
                    height: 50,
                    child: Text("Distance: " + distance().toString() + " km/h"),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      child: (_positionStreamSubscription == null ||
                              _positionStreamSubscription!.isPaused)
                          ? const Icon(Icons.play_arrow)
                          : const Icon(Icons.pause),
                      onPressed: () {
                        positionStreamStarted = !positionStreamStarted;
                        if (positionStreamStarted) {
                          startTimer();
                        } else {
                          stopTimer(resets: false);
                        }
                        _toggleListening();
                      },
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      child: const Icon(Icons.stop),
                      onPressed: () async => {
                        stopTimer(resets: false),
                        if (positionStreamStarted) {_toggleListening()},
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RunData(
                                    distance: distance(),
                                    duration: duration,
                                    points: points,
                                  )),
                        ),
                      },
                    ),
                  ]),
                  const Text("( * Y * )"),
                ]),
              ),
            ]),
      ),
    );
  }

  //////////////////////// TIMER //////////////////////////////
  static const countdownDuration = Duration();
  Duration duration = Duration();
  Timer? timer;
  bool countDown = false;

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'HOURS'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(header, style: const TextStyle(color: Colors.black45)),
        ],
      );
}
