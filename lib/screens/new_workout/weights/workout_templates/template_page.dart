import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/models/weight_lifting/weight_workout.dart';
import 'package:workout_app/models/weight_lifting/workout_template.dart';
import 'package:workout_app/screens/new_workout/weights/weightlift_screen.dart';
import 'package:workout_app/screens/new_workout/weights/workout_templates/create_template.dart';
import 'package:workout_app/services/database.dart';
import 'package:workout_app/shared/constants.dart';

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
      appBar: AppBar(title: const Text("Templates")),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              "Your templates",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: templates.length,
              itemBuilder: (BuildContext context, int index) {
                WorkoutTemplate template = templates[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 13),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Image.asset('lib/assets/weight.png')),
                          flex: 2),
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GradientText(
                                template.name,
                                gradientDirection: GradientDirection.btt,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                colors: const [
                                  Color(0xff4574EB),
                                  Color(0xff005FB7)
                                ],
                              ),
                              SingleChildScrollView(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: template.exercises.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () =>
                                          selectTemplate(template, context),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          template.exercises[index],
                                          style: const TextStyle(
                                              color: Color(0xff737373)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                            onPressed: () => deleteTemplate(template.id!),
                            icon: const Icon(Icons.delete,
                                color: Color(0xff737373))),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff0068C8),
        label: const Text("Create new template"),
        onPressed: () => addTemplate(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void selectTemplate(WorkoutTemplate template, BuildContext context) {
    WeightWorkout workout = WeightWorkout.template(template);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewWorkout.template(
                  workout: workout,
                )));
  }

  void addTemplate() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTemplate()),
    );
    if (result) {
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
