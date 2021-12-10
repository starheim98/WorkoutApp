import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/home/my_page/workout_details/weight_details.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';

class CustomWeightworkoutTile extends StatefulWidget {
  WeightWorkout weightWorkout;

  CustomWeightworkoutTile({Key? key, required this.weightWorkout})
      : super(key: key);

  @override
  _CustomWeightworkoutTileState createState() =>
      _CustomWeightworkoutTileState();
}

class _CustomWeightworkoutTileState extends State<CustomWeightworkoutTile> {
  DatabaseService databaseService = DatabaseService();
  String name = "";
  WeightWorkout? weightWorkout;

  @override
  void initState() {
    getName(widget.weightWorkout.uid!);
    weightWorkout = widget.weightWorkout;
    super.initState();
  }

  List<String> getExerciseNames(WeightWorkout weightWorkout) {
    List<Exercise> exercises = weightWorkout.exercises;
    List<String> names = [];
    for (Exercise exercise in exercises) {
      names.add(exercise.name);
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WorkoutDetailPage(workout: weightWorkout!)),
          )
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 1,
          child: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.2,
                padding: EdgeInsets.all(5),
                child: Icon(Icons.train), // RANDOM ICON TODO: Find something better
              ),

              Flexible( //Flexible for overflowing text
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      Text(name, style: tileName),
                      Text("\nWorkout name: " + weightWorkout!.name!, style: tileTitle),
                      Text(weightWorkout!.date!, style: tileDate),
                      Text("Time spent: " + weightWorkout!.duration.toString(), style: const TextStyle(overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  children: [
                    ListView.builder(
                        padding: const EdgeInsets.all(12.0),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: weightWorkout!.exercises.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                              child: Text(
                                  getExerciseNames(weightWorkout!)[index]));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getName(String uid) async {
    var result = await databaseService.getUser(uid);
    if (mounted){
      setState(() {
        name = result.getName();
      });
    }
  }
}
