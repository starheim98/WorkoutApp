import 'package:flutter/material.dart';

class Dialogues {

  confirmResult(bool isYes, BuildContext context){
    if (isYes) Navigator.pop(context, isYes);
    else Navigator.pop(context, isYes);
    
  }
    confirmDialogue(BuildContext context, String title, String description){
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
             return AlertDialog(
               title: Text(title),
               elevation: 24.0,
               content: SingleChildScrollView(
                 child: ListBody(
                   children: <Widget>[
                     Text(description),
                   ],
                 ),
               ),
               actions: <Widget>[
                 ElevatedButton(onPressed: () => confirmResult(false, context), child: const Text("No")),
                 ElevatedButton(onPressed: () => confirmResult(true, context), child: const Text("Yes"))
               ],
             );
          }
      );
  }
}