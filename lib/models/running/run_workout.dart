
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class RunWorkout {
   String _title;
   String _description;
   String _distance;
   String _duration;
   String _date;
   String _uid;
   String _id;

  List<dynamic> _geopoints;

   RunWorkout(this._title, this._description, this._distance, this._duration,
      this._geopoints, this._date, this._uid, this._id);

   factory RunWorkout.fromJson(Map<String, dynamic> json){
     String title = json['title'];
     String description = json['description'];
     String distance = json['distance'];
     String duration = json['duration'];
     List<dynamic> geopoints = json['geopoints'];
     String date = json['date'];
     String uid = json['userId'];
     String id = json['id'];
     return RunWorkout(title, description, distance, duration, geopoints, date, uid, id);
   }

   List<dynamic> get geopoints => _geopoints;

   String get id => _id;

   String get uid => _uid;

   List<LatLng> getPoints() {
     try {
       List<LatLng> points = <LatLng>[];
       for (GeoPoint geopoint in geopoints) {
         points.add(LatLng(geopoint.latitude, geopoint.longitude));
       }
       return points;
     } on Exception catch (e) {
       return []; //If there is no run connected to the data there will be no data to draw.
     }
   }

   String get date => _date;

   set date(String value) {
     date = value;
   }

   set geopoints(List<dynamic> value) {
    _geopoints = value;
  }

  String get duration => _duration;

  set duration(String value) {
    _duration = value;
  }

  String get distance => _distance;

  set distance(String value) {
    _distance = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}
