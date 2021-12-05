import 'package:flutter/material.dart';
import 'package:workout_app/screens/home/my_page/progression.dart';
import 'package:workout_app/screens/home/my_page/workouts.dart';

import 'friends.dart';

DefaultTabController myPageTab() =>
    DefaultTabController(
      length: 3,
      child: Column(children: <Widget>[
        TabBar(
          labelColor: Colors.amber[800],
          unselectedLabelColor: Colors.grey[800],
          labelStyle: TextStyle(fontSize: 18),
          tabs: const [
            Tab(text: "Workouts",),
            Tab(text: "Progression"),
            Tab(text: "Friends"),
          ],
        ),
        const Expanded(
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