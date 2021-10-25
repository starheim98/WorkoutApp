import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('My first flutter app'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0, //no dropshadow / flat on the screen
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
              print("User signed out.");
            },
            label: const Text("Logout"),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
