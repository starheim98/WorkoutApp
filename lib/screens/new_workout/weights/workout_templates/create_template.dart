import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/models/weight_lifting/workout_template.dart';
import 'package:workout_app/screens/new_workout/weights/workout_templates/template_page.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:workout_app/shared/select_exercise.dart';

class CreateTemplate extends StatefulWidget {
  const CreateTemplate({Key? key}) : super(key: key);

  @override
  _CreateTemplateState createState() => _CreateTemplateState();
}

class _CreateTemplateState extends State<CreateTemplate> {
  DatabaseService databaseService = DatabaseService();
  List<String> selectedExercises = [];
  String errorTitle = "";
  String errorExercises = "";
  AccountData? user;
  String title = "";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("New template"),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () => saveTemplate(context),
            child: const Text('Save'),
          ),
        ],

      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 22, bottom: 10),
                        child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,))
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: "Title your template"),
                        validator: (val)=> val!.isEmpty ? 'Title...' : null,
                        onChanged: (val) {
                          setState(() => title = val);
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          errorTitle,
                          style:  const TextStyle(color:Colors.red, fontSize: 14.0),
                        ),
                      )
                    ],
                  )
              ),
              const SizedBox(height: 20),
              const Text("Exercises", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                  errorExercises, style:const TextStyle(color:Colors.red, fontSize: 14.0)
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: selectedExercises.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                    child: ListTile(
                      title: Text(selectedExercises[index]),
                      trailing: IconButton(
                        onPressed: () => deleteExercise(index), icon: const Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => addExercise(context),
          label: const Text("         Add exercise         "),
          backgroundColor: const Color(0xff0068C8),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void deleteExercise(int index) {
    setState(() {
      selectedExercises.removeAt(index);
    });
  }

  void addExercise(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SelectExercise()));
    setState(() {
      selectedExercises.add(result);
    });
  }

  // TODO: UPDATE template page after saving
  void saveTemplate(BuildContext context) async {
    if(title.isEmpty) {
      setState(() {
        errorTitle = "You must name your template";
      });
    } else if (selectedExercises.isEmpty){
      setState(() {
        errorExercises = "No exercises added";
      });
    } else {
      user = await databaseService.getThisUser();
      WorkoutTemplate template = WorkoutTemplate.create(title, selectedExercises, user!.uid);
      databaseService.addTemplate(template);
      Navigator.pop(context, true);
    }
  }
}
