import 'package:flutter/material.dart';

class Progression extends StatefulWidget {
  const Progression({Key? key}) : super(key: key);

  @override
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text("Progression", style: TextStyle(fontSize: 25,)),
        ),
        // ListView.(
        //
        // )
      ],
    );
  }
}
