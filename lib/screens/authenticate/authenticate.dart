import 'package:flutter/material.dart';
import 'package:workout_app/screens/authenticate/register.dart';
import 'package:workout_app/screens/authenticate/login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return Login(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}