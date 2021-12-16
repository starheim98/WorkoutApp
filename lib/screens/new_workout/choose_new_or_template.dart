import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/screens/new_workout/weights/workout_templates/template_page.dart';
import 'package:workout_app/screens/new_workout/weights/weightlift_screen.dart';
import 'package:workout_app/shared/constants.dart';

class WeightLifting extends StatefulWidget {
  const WeightLifting({Key? key}) : super(key: key);

  @override
  State<WeightLifting> createState() => _WeightLiftingState();
}

class _WeightLiftingState extends State<WeightLifting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text("Weightlifting"),
        ),
        body: Center(
          child: Column(children: <Widget>[
            const SizedBox(
              height: 44,
            ),
            GestureDetector(
              onTap: () async => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TemplatePage()),
                )
              },
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Center(
                    child: GradientText(
                      "Select from template",
                      gradientDirection: GradientDirection.btt,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      colors: const [Color(0xff4574EB), Color(0xff005FB7)],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () async => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewWorkout()),
                )
              },
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: Center(
                      child: GradientText(
                        "New workout",
                        gradientDirection: GradientDirection.btt,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        colors: const [Color(0xff4574EB), Color(0xff005FB7)],
                      ),
                    )),
              ),
            ),
          ]),
        ));
  }
}
