import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RunData extends StatefulWidget {
  final double distance;
  final Duration duration;

  RunData({required this.distance, required this.duration});

  @override
  _RunDataState createState() => _RunDataState();
}

class _RunDataState extends State<RunData> {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('users'); //reference to the users collection.
  final CollectionReference runs = FirebaseFirestore.instance.collection('runs'); //reference to the users collection.

  final AuthService _auth = AuthService();
  String title = "";
  String desc = "";

  var sizedbox = SizedBox(height: 30);
  var document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbar(_auth, "Home"),
        body: Center(
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
              Text("Distance: " + widget.distance.toString()),
              sizedbox,
              Text("Duration: " + widget.duration.toString()),
              sizedbox,
              const Text("This is a sample photo. Your run will show after save.", style: TextStyle(fontStyle: FontStyle.italic)
              ),
              Image.asset('lib/assets/Sample.PNG',height: 240,),
              ElevatedButton(
                onPressed: ()  => {
                      //TODO: SEND RUN-DATA TO DATABASE
                      saveRun(title, desc, widget.duration, widget.distance),
                      Navigator.of(context).popUntil((route) => route.isFirst),
                    },
                child: const Text("Save Run"),
              ),
        ])));
   }

  //Add LATLNG
  Future<void> saveRun(String title, String desc, Duration duration, double distance) async {
    if(title.isEmpty) title = "Went for a run today!";
    await runs.doc().set({
      "title" : title,
      "description" : desc,
      "duration" : duration.toString(),
      "distance" : distance.toString(),
    });
  }

  Future<String> getEmailOfCurrentUser() async {
    var docSnapshot = await users.doc(_firebaseAuth.currentUser!.email).get();
    String value = "";

    if(docSnapshot.exists){
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      value = data?["email"];
      print(value);
    }
    return value;
  }

  //RUN WORKOUT:
  //title
  //desc
  //LatLng data - geolocation
  //distance
  //duration
}

