import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/home/my_page/workout_details/weight_details.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:intl/intl.dart';

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
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 1,
          child: Row(
            children: [
              Flexible( //Flexible for overflowing text
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: tileName),
                      Text(weightWorkout!.name!, style: tileTitle),
                      Text(formattedDate(weightWorkout!.date!), style: tileDate),
                      Text("Workout duration: " + weightWorkout!.duration.toString(), style: numberStyle),
                    ],
                  ),
                ),
              ),
              Container(

                decoration: BoxDecoration(border: Border.all(color: Colors.black12)),

                width: MediaQuery.of(context).size.width * 0.43,
                child: ConstrainedBox(
                constraints:  BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.175),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: weightWorkout!.exercises.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      dense: true,
                      title: Text(weightWorkout!.exercises[index].name, style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                      subtitle: Text(weightWorkout!.exercises[index].sets!.length.toString() + " sets", style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                    );
                  },
                ),
              )
                ),
            ],
          ),
        ),
      ),
    );
  }

/*  ListView.builder(
  padding: const EdgeInsets.all(12.0),
  scrollDirection: Axis.vertical,
  shrinkWrap: true,
  itemCount: weightWorkout!.exercises.length,
  itemBuilder: (BuildContext context, int index) {
  return Center(
  child: Text(
  getExerciseNames(weightWorkout!)[index]));
  }),
  */

  String formattedDate(String now){
    DateTime haha = DateTime.parse(now);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(haha);
    return formatted;
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
