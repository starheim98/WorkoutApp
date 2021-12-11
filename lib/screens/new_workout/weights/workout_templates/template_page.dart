
import 'package:flutter/material.dart';
import 'package:workout_app/models/weight_lifting/template.dart';
import 'package:workout_app/models/weight_lifting/workout_template.dart';
import 'package:workout_app/screens/new_workout/weights/workout_templates/create_template.dart';
import 'package:workout_app/services/database.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({Key? key}) : super(key: key);

  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  DatabaseService databaseService = DatabaseService();
  List<WorkoutTemplate> templates = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

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
                return Card(
                  child: ListTile(
                    onTap: () => selectTemplate(template, context),
                    title: Text(template.name),
                    trailing: IconButton(
                      onPressed: () => deleteTemplate(template.id!), icon: const Icon(Icons.delete),
                    ),
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


  void selectTemplate(WorkoutTemplate template, BuildContext context){
    // Navigator.push(context)
  }

  void addTemplate() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CreateTemplate()),
    );
    if(result){
      print("test=");
      fetchData();
    }
  }

  void fetchData() async {
    var result = await databaseService.getTemplates();
    setState(() {
      templates = result;
    });
  }
  void deleteTemplate(String id) async {
    var result = await databaseService.deleteTemplate(id);
    fetchData();
  }
}


