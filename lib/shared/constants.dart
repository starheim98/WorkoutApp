import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';

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

/// AppBar - TODO: Move to better named file? or not
appbar(AuthService _auth, String title) => AppBar(
  title: Text(title),
  backgroundColor: Colors.brown[400],
  elevation: 0.0, //no dropshadow / flat on the screen
  actions: <Widget>[
    TextButton.icon(
      onPressed: () async {
        await _auth.signOut();
      },
      label: const Text("Logout"),
      icon: const Icon(Icons.person),
    ),
  ],
);