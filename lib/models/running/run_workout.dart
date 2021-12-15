
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

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
       if(geopoints.isEmpty){
         points.add(LatLng(62.4725696,6.2362148)); //NTNU
       }

       return points;
     } on Exception catch (e) {
       return []; //If there is no run connected to the data there will be no data to draw.
     }
   }

   String get date => _date;

   String getDate() {
       DateTime parsedDateTime = DateTime.parse(date);
       final DateFormat formatter = DateFormat('yyyy-MM-dd');
       final String formattedDate = formatter.format(parsedDateTime);
       return formattedDate;
   }

   String getDuration() {
     int hours = 0;
     int minutes = 0;
     int micros;
     List<String> parts = _duration.split(':');
     if (parts.length > 2) {
       hours = int.parse(parts[parts.length - 3]);
     }
     if (parts.length > 1) {
       minutes = int.parse(parts[parts.length - 2]);
     }
     micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
     Duration duration = Duration(hours: hours, minutes: minutes, microseconds: micros);

     String twoDigits(int n) => n.toString().padLeft(2, "0");
     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
   }

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
