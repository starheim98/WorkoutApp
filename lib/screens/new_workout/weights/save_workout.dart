import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';

class SaveWeightWorkout extends StatefulWidget {
  WeightWorkout workout;
  SaveWeightWorkout({Key? key, required this.workout}) : super(key: key);

  @override
  _SaveWeightWorkoutState createState() => _SaveWeightWorkoutState();
}

class _SaveWeightWorkoutState extends State<SaveWeightWorkout> {
  DatabaseService databaseService = DatabaseService();
  String title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Save your workout")
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              SizedBox(
                  width: 350,
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Title your workout"),
                    validator: (val)=> val!.isEmpty ? 'Title...' : null,
                    onChanged: (val) {
                      setState(() => title = val);
                    },
                  )
              ),
              const SizedBox(height: 30),
              const Text("Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.workout.exercises.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: GradientText(
                        widget.workout.exercises[index].name,
                        gradientDirection: GradientDirection.btt,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        colors: const [Color(0xff4574EB), Color(0xff005FB7)],
                      ),
                      subtitle: Text(widget.workout.exercises[index].sets!.length.toString() + " sets"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text("     Save workout     "),
          backgroundColor: const Color(0xff0068C8),
          onPressed: () => finishWorkout()
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  finishWorkout() {
    if(title.isEmpty) {
      widget.workout.setName("Workout " + widget.workout.getDate()!);
    } else {
      widget.workout.setName(title);
    }
    widget.workout.finishWorkout();
    DatabaseService().addWeightWorkout(widget.workout);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
