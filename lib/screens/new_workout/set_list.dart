import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/exercise.dart';
import 'package:workout_app/models/weight_lifting/weight_set.dart';

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
        return Row(
          key: ObjectKey(set),
          children: <Widget>[
            Text((index + 1).toString()),
            const Flexible(
              child: TextField(
                  decoration: InputDecoration(
                      labelText: "repetitions",
                      contentPadding: EdgeInsets.all(10))),
            ),
            const Flexible(
              child: TextField(
                  decoration: InputDecoration(
                      labelText: "weight", contentPadding: EdgeInsets.all(10))),
            ),
            Flexible(
              child: IconButton(
                onPressed: () => deleteSet(set),
                icon: const Icon(Icons.close),
              ),
            )
          ],
        );
      },
    );
  }

  void deleteSet(WeightSet set) {
    setState(() {
      widget.exercise.sets!.remove(set);
    });
  }
}
