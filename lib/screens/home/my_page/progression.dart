import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Progression extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  Progression(this.seriesList, {this.animate = false});


  @override
  Widget build(BuildContext context) {
    return charts.LineChart(seriesList, animate: animate);
  }
}

/// Sample linear data type.
class LinearGraphData {
  final int week;
  final int weight;

  LinearGraphData(this.week, this.weight);
}