import 'package:flutter/material.dart';

class SelectExercise extends StatelessWidget {
  const SelectExercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'Benchpress');
                },
                child: const Text('Benchpress'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'Squat');
                },
                child: const Text('Squat'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
