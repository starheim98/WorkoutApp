import 'package:flutter/material.dart';
import 'package:workout_app/models/running/run_workout.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/home/home_tab/custom_run_tile.dart';
import 'package:workout_app/screens/home/home_tab/custom_weightworkout_tile.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/loading.dart';


class HomeTab extends StatefulWidget {
  List<RunWorkout> runWorkouts;
  List<WeightWorkout> weightWorkouts;
  List<dynamic> friendsWorkouts;

  HomeTab({Key? key, required this.runWorkouts, required this.weightWorkouts,
    required this.friendsWorkouts})
      : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DatabaseService databaseService = DatabaseService();
  String currentName = "";
  List<RunWorkout> runWorkouts = [];
  List<WeightWorkout> weightWorkouts = [];
  var friendsWorkouts = [];
  var workoutsList = [];
  bool loading = true;

  @override
  @mustCallSuper
  @protected
  void didUpdateWidget(covariant HomeTab oldWidget) {
    runWorkouts = widget.runWorkouts;
    weightWorkouts = widget.weightWorkouts;
    friendsWorkouts = widget.friendsWorkouts;

    setState(() {
      if(runWorkouts.length >= 1){
        loading = false;
      }
    });

    // TODO: reverse sort
    workoutsList = List.from(runWorkouts)
      ..addAll(weightWorkouts)
      ..addAll(friendsWorkouts);
    workoutsList.sort((a, b) => a.date.compareTo(b.date));

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : ListView.builder(
      itemCount: workoutsList.length,
      itemBuilder: (BuildContext context, int index) {
        if (workoutsList[index] is RunWorkout) {
          return CustomRunTile(runWorkout: workoutsList[index]);
        } else if (workoutsList[index] is WeightWorkout) {
          return CustomWeightworkoutTile(weightWorkout: workoutsList[index]);
        }
        return const Text("No data");
      },
    );
  }
}
