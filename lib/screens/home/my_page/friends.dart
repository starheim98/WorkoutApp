import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/services/database.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<AccountData> foundAccounts = [];
  List<AccountData> friends = [];
  DatabaseService databaseService = DatabaseService();
  AccountData? user;
  String searchField = "";

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    var result = await databaseService.getUser(_firebaseAuth.currentUser!.uid);
    user = result;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 30),
        TextField(
            onChanged: (query) => {
              searchField = query,
              onSearch(query)
            },
            decoration: const InputDecoration(hintText: "Find friends")),
        const SizedBox(height: 20),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: foundAccounts.length,
          itemBuilder: (BuildContext context, int index) {
            if (user!.isFriendWith(foundAccounts[index].uid)) {
              return friendTile(foundAccounts[index]);
            } else {
              return notFriendTile(foundAccounts[index]);
            }
          },
        )
      ],
    );
  }

  ListTile friendTile(AccountData account) => ListTile(
        title: Text(account.getName()),
        trailing: IconButton(
          onPressed: () => unfollowUser(account.uid),
          icon: const Icon(Icons.person_remove),
        ),
      );

  ListTile notFriendTile(AccountData account) => ListTile(
        title: Text(account.getName()),
        trailing: IconButton(
            onPressed: () => followUser(account.uid),
            icon: const Icon(Icons.person_add)),
      );

  void onSearch(String query) async {
    var result = await databaseService.findAccounts(query);
    setState(() {
      foundAccounts = result;
    });
  }

  Future followUser(String uid) async {
    bool result = await databaseService.followUser(uid);
    if(result) {
      setState(() {
        onSearch(searchField);
      });
    }
  }

  Future unfollowUser(String uid) async {
    bool result = await databaseService.unfollowUser(uid);
    if(result) {
      setState(() {
        onSearch(searchField);
      });
    }
  }
}
