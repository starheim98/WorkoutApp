
import 'package:flutter/material.dart';
import 'package:workout_app/screens/new_workout/weights/workout_templates/create_template.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({Key? key}) : super(key: key);

  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  List<WorkoutTemplate> templates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Templates")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            const Text("Your templates", style: TextStyle(fontSize: 25),),
            SizedBox(height: 20),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: templates.length,
              itemBuilder: (BuildContext context, int index) {
                WorkoutTemplate template = templates[index];
                return ListTile(
                  title: Text(template.name),
                  trailing: IconButton(
                    onPressed: () => deleteTemplate(template.id), icon: Icon(Icons.delete),
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Create new template"),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateTemplate()),
          )
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void addTemplate() {
    // todo
  }

  void deleteTemplate(String id) {
    // todo
  }
}

class WorkoutTemplate {
  String name;
  List<String> exercises = [];
  String userId;
  String id;


  WorkoutTemplate(this.name, this.exercises, this.userId, this.id);
}
