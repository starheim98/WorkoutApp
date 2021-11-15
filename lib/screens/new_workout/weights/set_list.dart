import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_set.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/screens/new_workout/weights/set_tile.dart';

class SetList extends StatefulWidget {
  Exercise exercise;

  SetList({Key? key, required this.exercise}) : super(key: key);

  @override
  _SetListState createState() => _SetListState();
}

class _SetListState extends State<SetList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.exercise.getSets()!.length,
      itemBuilder: (BuildContext context, int index) {
        WeightSet set = widget.exercise.getSets()![index];
        return SetTile(
          key: ObjectKey(set),
            deleteSet: deleteSet,
            set: widget.exercise.getSets()![index],
            index: index);
      },
    );
  }

  void deleteSet(WeightSet set) {
    setState(() {
      widget.exercise.sets!.remove(set);
    });
  }
}
