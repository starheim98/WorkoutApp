import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:workout_app/screens/home/my_page/graph.dart';
import 'package:workout_app/shared/select_exercise.dart';

class Progression extends StatefulWidget {
  const Progression({Key? key}) : super(key: key);

  @override
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  String selectedExercise = "";
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          SizedBox(
            width: 250,
            child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: const Color(0xff0068C8)),
                child: const Text("Select an exercise"),
                onPressed: () => selectExercise(context)),
          ),
          const SizedBox(height: 70),
          const Text(
            "Select an exercise to display your progression",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: const Color(0xff0068C8)),
                child: const Text("Select another exercise"),
                onPressed: () => setState(() {
                  isSelected = false;
                  selectExercise(context);
                }),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              selectedExercise,
              style: const TextStyle(fontSize: 20),
            ),
            ConstrainedBox(
              child: ProgressionGraph(
                  exercise: selectedExercise, isSelected: isSelected),
              constraints: const BoxConstraints(maxHeight: 300),
            ),
          ],
        ),
      );
    }
  }

  void selectExercise(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SelectExercise()));
    setState(() {
      selectedExercise = result;
      isSelected = true;
    });
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  List<charts.Series<LinearGraphData, num>> setupGraphData() {
    final data = <LinearGraphData>[];
    int index = 0;

    return [
      charts.Series<LinearGraphData, int>(
        id: 'WeightGraph',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearGraphData sales, _) => sales.week,
        measureFn: (LinearGraphData sales, _) => sales.weight,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearGraphData {
  final int week;
  final int weight;

  LinearGraphData(this.week, this.weight);
}
