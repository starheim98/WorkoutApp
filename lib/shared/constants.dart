import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/Dialogues.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0)));

const backgroundColor = Color(0xffEFEBE9);

const flutterMapIcon = Icon(
  Icons.radio_button_on_outlined,
  color: Colors.blue,
);

const durationDistanceAvgPaceText = TextStyle(
  fontFamily: "Roboto",
  fontWeight: FontWeight.normal,
  fontSize: 12 + 2,
  color: Color(0xFF737373),
);

//Tiles
const tileName = TextStyle(
  overflow: TextOverflow.ellipsis,
  fontSize: 12 + 2,
  fontFamily: "Roboto",
);

const tileTitle = TextStyle(
  fontWeight: FontWeight.bold,
  overflow: TextOverflow.ellipsis,
  fontSize: 16 + 2,
);

const numberStyle = TextStyle(
  overflow: TextOverflow.ellipsis,
  fontFamily: "Roboto",
  fontSize: 12 + 2,
  fontWeight: FontWeight.normal,
  height: 1.3,
);

const detailsName = TextStyle(
  fontFamily: "Roboto",
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.bold,
  fontSize: 16 + 2,
);

const dialogueFont = TextStyle(
  fontSize: 16 + 2,
  fontFamily: "Roboto",
  fontStyle: FontStyle.normal,
);

/// AppBar
appbar(AuthService _auth, String name, BuildContext context) => AppBar(
      title: Text(name),
      elevation: 0.0, //no dropshadow / flat on the screen
      actions: <Widget>[
        TextButton.icon(
          onPressed: () async {
            var value = await Dialogues().confirmLogoutDialogue(
                context, "Logout", "Are you sure you want to logout?");
            if (value) {
              await _auth.signOut();
            }
          },
          label: const Text(
            "Log out",
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
