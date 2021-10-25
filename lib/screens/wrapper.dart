import 'package:flutter/material.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Account?>(context);

    if(user == null){
      return const Authenticate();
    } else {
      return Home();
    }
    //return either Home or Authenticate widget.
  }
}
