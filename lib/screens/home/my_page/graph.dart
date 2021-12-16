import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:workout_app/services/database.dart';

class ProgressionGraph extends StatefulWidget {
  String exercise;
  bool isSelected;

  ProgressionGraph({Key? key, required this.exercise, required this.isSelected})
      : super(key: key);

  @override
  _ProgressionGraphState createState() => _ProgressionGraphState();
}

class _ProgressionGraphState extends State<ProgressionGraph> {
  DatabaseService databaseService = DatabaseService();
  List<DateAndWeight> data = [];

  // List<charts.Series<DateAndWeight>> series = [];
  bool animate = false;

  @override
  void initState() {
    fetchExerciseData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DateAndWeight, DateTime>> series = [
      charts.Series(
        id: "exercise",
        data: data,
        domainFn: (DateAndWeight series, _) => series.date,
        measureFn: (DateAndWeight series, _) => series.weight,
      )
    ];
    if (data.length <= 1) {
      return Column(
        children: const <Widget>[
          SizedBox(height: 30),
          Text("Not enough data collected")
        ],
      );
    } else {
      return charts.TimeSeriesChart(
        series,
        animate: true,
        behaviors: [
          charts.ChartTitle('Date',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleStyleSpec: const charts.TextStyleSpec(fontSize: 15),
              titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
          charts.ChartTitle('Weight, kg',
              behaviorPosition: charts.BehaviorPosition.start,
              titleStyleSpec: const charts.TextStyleSpec(fontSize: 15),
              titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea)
        ],
      );
    }
  }

  void fetchExerciseData() async {
    var result = await databaseService.getExerciseData(widget.exercise);
    result.sort((a, b) => a.date.compareTo(b.date));
    setState(() {
      data = result;
    });
  }
}

class DateAndWeight {
  final DateTime date;
  final int weight;

  DateAndWeight(this.date, this.weight);
}
