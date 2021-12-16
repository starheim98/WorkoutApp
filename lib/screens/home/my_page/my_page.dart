import 'package:flutter/material.dart';
import 'package:workout_app/screens/home/my_page/progression.dart';
import 'package:workout_app/screens/home/my_page/workouts.dart';

import 'friends.dart';

DefaultTabController myPageTab() => DefaultTabController(
      length: 3,
      child: Column(children: const <Widget>[
        TabBar(
          labelColor: Color(0xff28A8F0),
          unselectedLabelColor: Colors.black,
          labelStyle: TextStyle(fontSize: 18),
          tabs: [
            Tab(text: "Workouts"),
            Tab(text: "Progression"),
            Tab(text: "Friends"),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: <Widget>[
              MyWorkouts(),
              Progression(),
              Friends(),
            ],
          ),
        )
      ]),
    );
