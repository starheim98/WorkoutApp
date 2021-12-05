import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/services/database.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final TextEditingController _controller = TextEditingController();
  List<AccountData> foundAccounts = [];
  List<AccountData> friends = [];
  DatabaseService? databaseService;


  // @mustCallSuper
  // @protected
  // void didUpdateWidget() {
  //   super.initState();
  //   databaseService = DatabaseService();
  //   print("test");
  // }

  // @override
  // @mustCallSuper
  // @protected
  // void didUpdateWidget(covariant T oldWidget) { }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 30),
        TextField(
          onChanged: (query) => onSearch(query),
          decoration: const InputDecoration(hintText: "Find friends")
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: foundAccounts.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(foundAccounts[index].email);
          },
        )
      ],
    );
  }

  void onSearch(String query) async {
    var result = await databaseService?.findAccounts(query) ?? [];

  }
}
