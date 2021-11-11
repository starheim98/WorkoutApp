import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

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
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  Position? position;
  double longitude = 6.235902420311039;
  double latitude = 62.472207764237886;

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
    mapController?.move(LatLng(latitude, longitude), 18);
    //            mapController?.move(LatLng(position.latitude, position.longitude), 15);
  }


  void _toggleListening() {
    positionStream = Geolocator.getPositionStream().listen(
            (Position position) {
            print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
              refreshToCurrentPosition();
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
                  refreshToCurrentPosition();
                },
              ),
              sizedBox,
              FloatingActionButton(
              child:
                  const Icon(Icons.play_arrow),
                  onPressed: () {
                    _toggleListening();
                  },
              ),
            ]));
  }
}

/*

/// LOOK : https://www.mapbox.com/ https://pub.dev/packages/flutter_map
/// SAUCE: https://www.youtube.com/watch?v=McPzVZZRniU - fungerer ikke. HAR FJERNET API KEY OG DELETET.
class _RunningState extends State<Running> {
  String buttonText = "Record";
  Marker? marker;
  GoogleMapController? _controller;
  StreamSubscription? _locationSubscription;
  Location _locationTracker = Location();

  static const CameraPosition initialLocation = CameraPosition(target:LatLng(35,23), zoom:15);

  //Converting our pointer asset into byte data so it can be used in "get current location".
  Future<Uint8List> getMarker() async{
    ByteData byteData = await DefaultAssetBundle.of(context).load("lib/assets/pointer.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarker(LocationData newLocalData, Uint8List imageData){
     LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
     setState(() {
       marker = Marker(
         markerId: const MarkerId("marker"),
         position: latlng,
         rotation: newLocalData.heading!,
         draggable: false,
         zIndex: 2, // if u use a circle under u need this. We dont
         flat:true, // if u tilt the map u are flat, etc
         anchor: const Offset(0.5, 0.5), // the TOP of the pointer will be the middle - we want center of pointer - add offset.
         icon: BitmapDescriptor.fromBytes(imageData) //Marker icon
       );
     });
  }

  void getCurrentLocation() async {
    try{
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation(); // get location async
      updateMarker(location, imageData);

      if(_locationSubscription != null){
        _locationSubscription!.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData){ //always checks for changes in location
        if(_controller != null){
          _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              bearing: 192.833394319423,
              target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
              tilt: 0,
              zoom: 18.00)));
          updateMarker(newLocalData, imageData); // update current location
        }
      });

    } on PlatformException catch (e){
      if (e.code == 'PERMISSION_DENIED'){
        debugPrint("Permission denied");
      } else print(e);
    }
  }

  @override
  void dispose(){
    if(_locationSubscription != null){
      _locationSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Running"),
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: initialLocation,
        markers: Set.of((marker != null) ? [marker!] : []) ,
        onMapCreated: (GoogleMapController controller){
          controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching),
        onPressed: (){
          getCurrentLocation();
        },
      ),
    );
  }
}

Center(
child: ElevatedButton(
onPressed: () {setState(() => buttonText = "Loading");},
child: Text(buttonText),
),
),*/
