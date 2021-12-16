import 'package:flutter/material.dart';

import 'constants.dart';

class Dialogues {
  confirmResult(bool isYes, BuildContext context) {
    if (isYes) {
      Navigator.pop(context, isYes);
    } else {
      Navigator.pop(context, isYes);
    }
  }

  confirmLogoutDialogue(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: dialogueFont),
            elevation: 24.0,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description, style: dialogueFont),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: const Icon(
                      Icons.exit_to_app,
                      ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFEA323D))),
                        onPressed: () => confirmResult(true, context),
                        label: const Text("Logout", style: dialogueFont)),
                    ElevatedButton.icon(
                        icon: const Icon(
                          Icons.cancel,
                          color: Color(0xFF333333),
                        ),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                        onPressed: () => confirmResult(false, context),
                        label: Text("Cancel", style: dialogueFont.copyWith(color: const Color(0xFF333333)))),
                  ],
                ),
              ),
            ],
          );
        });
  }

  confirmDeleteDialogue(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: dialogueFont),
            elevation: 24.0,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description, style: dialogueFont),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.delete,
                      ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFEA323D))
                        ),
                        onPressed: () => confirmResult(true, context),
                        label: const Text("Delete", style: dialogueFont)),
                    ElevatedButton.icon(
                        style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.white)
                        ),
                        icon: const Icon(
                          Icons.cancel,
                          color: Color(0xFF333333),
                        ),
                        onPressed: () => confirmResult(false, context),
                        label: Text("Cancel", style: dialogueFont.copyWith(color: const Color(0xFF333333)))),

                  ],
                ),
              ),
            ],
          );
        });
  }
}
