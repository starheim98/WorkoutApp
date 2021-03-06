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
  bool loading;

  HomeTab(
      {Key? key,
      required this.runWorkouts,
      required this.weightWorkouts,
      required this.friendsWorkouts,
      required this.loading})
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
    loading = widget.loading;
    runWorkouts = widget.runWorkouts;
    weightWorkouts = widget.weightWorkouts;
    friendsWorkouts = widget.friendsWorkouts;
    fetchData();
    workoutsList = List.from(runWorkouts)
      ..addAll(weightWorkouts)
      ..addAll(friendsWorkouts);
    workoutsList.sort((b, a) => a.date.compareTo(b.date));

    super.didUpdateWidget(oldWidget);
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    loading = true;
    super.dispose();
  }

  Future fetchData() async {
    var runsData = await databaseService.getRunsData();
    var weightWorkoutData = await databaseService.getWeightWorkouts();
    var friendsWO = await databaseService.getFriendsWorkouts();
    if (mounted) {
      setState(() {
        runWorkouts = runsData;
        weightWorkouts = weightWorkoutData;
        friendsWorkouts = friendsWO;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    } else if (workoutsList.length >= 1) {
      return ListView.builder(
        itemCount: workoutsList.length,
        itemBuilder: (BuildContext context, int index) {
          if (workoutsList[index] is RunWorkout) {
            return CustomRunTile(runWorkout: workoutsList[index]);
          } else if (workoutsList[index] is WeightWorkout) {
            return CustomWeightworkoutTile(weightWorkout: workoutsList[index]);
          } else {
            return const Text("no data");
          }
        },
      );
    } else {
      return const Text("Follow someone you know to see their workouts");
    }
  }
}
