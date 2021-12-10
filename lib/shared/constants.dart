import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/Dialogues.dart';


const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0)
    )
);

const flutterMapIcon = Icon(
    Icons.radio_button_on_outlined,
    color: Colors.blue,
);

const textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
    fontFamily: 'Georgia',
);

//Tiles
const tileName = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontSize: 12,
    fontFamily: "Georgia",
);

const tileDate = TextStyle(fontSize: 10);
const tileTitle = TextStyle(
  fontWeight: FontWeight.bold,
  overflow: TextOverflow.ellipsis,
    fontSize: 15,
);
//

/// AppBar - TODO: Move to better named file? or not
appbar(AuthService _auth, String name, BuildContext context) => AppBar(
  title: Text(name),
  backgroundColor: Colors.red[400], //DEN VAR brown[400]
  elevation: 0.0, //no dropshadow / flat on the screen
  actions: <Widget>[
    TextButton.icon(
      onPressed: () async {
        var value = await Dialogues().confirmDialogue(context, "Logout", "Are you sure you want to logout?");
        if(value){
          await _auth.signOut();
        }
      },
      label: const Text("Logout"),
      icon: const Icon(Icons.person),
    ),
  ],
);


