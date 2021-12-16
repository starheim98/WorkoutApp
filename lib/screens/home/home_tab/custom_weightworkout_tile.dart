import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
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
      margin: const EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9),
      elevation: 3,
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
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 1,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                //Flexible for overflowing text
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Image.asset(
                                'lib/assets/weight.png',
                                alignment: Alignment.topLeft,
                                height: 45,
                              ),
                              flex: 1),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: tileName,
                                ),
                                GradientText(weightWorkout!.name!,
                                    gradientDirection: GradientDirection.btt,
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 14.0 + 2,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    colors: const [
                                      Color(0xFF4574EB),
                                      Color(0xFF005FB7),
                                    ]),
                                Text(
                                  weightWorkout!.getDate()!,
                                  style: numberStyle.copyWith(height: 1.5),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Duration",
                                      style: durationDistanceAvgPaceText
                                          .copyWith(height: 1.5),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      weightWorkout!.getDuration(),
                                      style: numberStyle.copyWith(height: 1.5),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    height: double.infinity, //match parent POG
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: weightWorkout!.exercises.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  weightWorkout!.exercises[index].name,
                                  style:
                                      const TextStyle(fontSize: 12 + 2, height: 1.5),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    weightWorkout!.exercises[index].sets!.length
                                            .toString() +
                                        "sets ",
                                    style: const TextStyle(
                                        fontSize: 12 + 2,
                                        color: Color(0xFF737373)))),
                          ],
                        );
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }


  Future getName(String uid) async {
    var result = await databaseService.getUser(uid);
    if (mounted) {
      setState(() {
        name = result.getName();
      });
    }
  }
}
