import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:workout_app/models/running/run_workout.dart';

class Progression extends StatefulWidget {
  // final List<charts.Series<dynamic, num>> seriesList;
  // final bool animate;
  const Progression({Key? key}) : super(key: key);

  @override
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  @override
  Widget build(BuildContext context) {
    // return charts.LineChart(seriesList, animate: animate);
    return Container();
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

    // for(RunWorkout runWorkout in runWorkouts ) {
    //   Duration duration = parseDuration(runWorkout.duration);
    //   int perminute = duration.inSeconds;
    //   if (perminute!=0){
    //     double kmh = double.parse(runWorkout.distance) / perminute;
    //     print("km/h:"+kmh.toString());
    //     index ++;
    //     data.add(LinearGraphData(index, kmh.round()));
    //   }
    // }

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
