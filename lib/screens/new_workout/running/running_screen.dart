import 'dart:async';

import 'package:workout_app/shared/constants.dart';

import '../../../top_secret.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapstool;
import 'package:workout_app/screens/new_workout/running/running_save_run.dart';
import 'package:wakelock/wakelock.dart';

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

  bool recording = false;

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  void initState() {
    _toggleListening();
    super.initState();
    reset();
    mapController = MapController();
  }

  void refreshToCurrentPosition() {
    if (mounted) {
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

  void _updatePositionList(Position position) {
    if (!_positionItems.contains(position)) {
      _positionItems.add(position);
    }
    if (mounted) setState(() {});
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = geolocatorPlatform.getPositionStream(
          desiredAccuracy: LocationAccuracy.best);
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => {
            if (recording && mounted)
              {
                setState(() {
                  _updatePositionList(position);
                  updatePoints();
                }),
              },
            refreshToCurrentPosition(),
          });
      _positionStreamSubscription?.pause();
    }
    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
      } else {
        _positionStreamSubscription!.pause();
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
    distance = distance.floorToDouble(); //Rounding to make it readable
    distance = distance / 1000; // M -> KM

    return distance;
  }

  onBuild(){
    _toggleListening();
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
                        tileLayerOptions,
                        MarkerLayerOptions(
                          markers: [
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: LatLng(latitude, longitude),
                              builder: (ctx) => flutterMapIcon,
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
                    child: Text(distance().toString() + " km",
                      style:
                        const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                          ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      child: icson(),
                      onPressed: () {
                        recording = !recording;
                        if (mounted) {
                          setState(() {
                            Wakelock.enable();
                          });
                        }
                        positionStreamStarted = !positionStreamStarted;
                        if (recording) {
                          startTimer();
                        } else {
                          stopTimer(resets: false);
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      child: const Icon(Icons.stop),
                      onPressed: () async => {
                        Wakelock.disable(),
                        stopTimer(resets: false),

                            recording = false,
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
                ]),
              ),
            ]),
      ),
    );
  }

  Icon icson() {
    Icon icon = Icon(Icons.play_arrow);
    if (recording == false) {
      setState(() {
        icon = Icon(Icons.play_arrow);
      });
    } else if (recording == true) {
      setState(() {
        icon = const Icon(Icons.pause);
      });
    }
    return icon;
  }

  //////////////////////// TIMER //////////////////////////////
  static const countdownDuration = Duration();
  Duration duration = Duration();
  Timer? timer;
  bool countDown = false;

  void reset() {
    if (mounted) {
      if (countDown) {
        setState(() => duration = countdownDuration);
      } else {
        setState(() => duration = const Duration());
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;
        if (seconds < 0) {
          timer?.cancel();
        } else {
          duration = Duration(seconds: seconds);
        }
      });
    }
  }

  void stopTimer({bool resets = true}) {
    if (mounted) {
      if (resets) {
        reset();
      }
      setState(() => timer?.cancel());
    }
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
