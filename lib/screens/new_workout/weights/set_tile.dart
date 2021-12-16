import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/weight_set.dart';
import 'package:flutter/services.dart';

class SetTile extends StatefulWidget {
  Function deleteSet;
  WeightSet set;
  int index;

  SetTile(
      {Key? key,
      required this.deleteSet,
      required this.set,
      required this.index})
      : super(key: key);

  @override
  _SetTileState createState() => _SetTileState();
}

class _SetTileState extends State<SetTile> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repetitionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.set.getWeight() != 0) {
      _weightController.text = widget.set.getWeight().toString();
    }
    if (widget.set.getRepetitions() != 0) {
      _repetitionController.text = widget.set.getRepetitions().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text((widget.index + 1).toString()),
        ),
        Expanded(
          flex: 5,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (reps) => updateRepetitions(reps),
            controller: _repetitionController,
            decoration: const InputDecoration(
                labelText: "repetitions", contentPadding: EdgeInsets.all(10)),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _weightController,
            onChanged: (text) => updateWeight(text),
            decoration: const InputDecoration(
              labelText: "weight",
              contentPadding: EdgeInsets.all(10),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: IconButton(
            onPressed: () => widget.deleteSet(widget.set),
            icon: const Icon(Icons.close),
          ),
        )
      ],
    );
  }

  void updateWeight(String text) {
    int weight = int.tryParse(text) ?? 0;
    if (weight is int) {
      widget.set.setWeight(weight);
    }
  }

  updateRepetitions(String text) {
    int reps = int.tryParse(text) ?? 0;
    if (reps is int) {
      widget.set.setRepetitions(reps);
    }
  }
}
