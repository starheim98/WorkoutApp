import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';

class WorkoutDetailPage extends StatefulWidget {
  WeightWorkout workout;

  WorkoutDetailPage({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  DatabaseService? databaseService;
  String firstName = "";

  @override
  void initState() {
    databaseService = DatabaseService();
    fetchUser();
    super.initState();
  }

  Future fetchUser() async {
    var user = await databaseService!.getThisUser();
    if (mounted) {
      setState(() {
        firstName = user.firstName;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = widget.workout.exercises;
    for (Exercise exercise in exercises) {
      exercise.name;
    }

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(widget.workout.name!),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(
                          firstName,
                          style: detailsName,
                        ),
                          GradientText(
                              widget.workout.name!,
                              style: const TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 16.0 + 2,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                              colors: const [
                                Color(0xFF4574EB),
                                Color(0xFF005FB7),
                              ]
                          ),
                          Text(widget.workout.getDate()!,
                          style: numberStyle.copyWith(height:1.5),),
                        ],
                      ),
                    ),
                    Expanded(child: Image.asset('lib/assets/weight.png', height: 40), flex: 1),
                  ],
                ),

                Row(
                  children: [
                     Text(
                      "Duration",
                      style: durationDistanceAvgPaceText.copyWith(height: 1.5),
                    ),
                    SizedBox(width:10),
                    Text(
                      widget.workout.getDuration(),
                      style: numberStyle.copyWith(height:1.5),
                    ),
                  ],
                ),

                const Text(
                  "Exercises",
                  style: detailsName,
                ),
                
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: exercises.length,
                    itemBuilder: (BuildContext context, int index) {
                      return thing(exercises[index]);
                    }),
              ],
            ),
          ),
        ));
  }

}

thing(Exercise exercise) => Card(
  elevation: 3,
  margin: const EdgeInsets.only(left:0, right:0, top: 16),

  child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            exercise.name,
            gradientDirection: GradientDirection.btt,
            colors: const [
              Color(0xFF4574EB),
              Color(0XFF005FB7),
            ],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            itemCount: exercise.sets!.length,
              itemBuilder: (BuildContext context, int index){
            return Row(
              children: [
                Expanded(flex: 1, child: Text("Set " + (index+1).toString() +  " ", style: const TextStyle(height: 1.5))),
                Expanded(flex: 1, child: Text(exercise.sets![index].getRepetitions().toString()+ " reps")),
                Expanded(flex: 1, child: Text(exercise.sets![index].getWeight().toString() + " kg")),
              ],
            );
          })
        ],
      ),
    ),
);
