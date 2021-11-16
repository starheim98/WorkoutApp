import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';

class RunData extends StatefulWidget {
  final double distance;
  final Duration duration;

  RunData({required this.distance, required this.duration});

  @override
  _RunDataState createState() => _RunDataState();
}

class _RunDataState extends State<RunData> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    String title = "";
    String desc = "";
    //TODO: PHOTO / MAP.

    var sizedbox = SizedBox(height: 30);
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
                onPressed: () =>
                    {
                      //TODO: SEND RUN-DATA TO DATABASE
                      Navigator.of(context).popUntil((route) => route.isFirst)
                    },
                child: const Text("Save Run"),
              ),
        ])));
  }
}
