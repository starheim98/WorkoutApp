import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';
import 'package:workout_app/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = new AuthService();
  final _formkey = GlobalKey<FormState>();

  bool loading = false;
  String email = "";
  String password = "";
  String error = "";
  String firstName = "";
  String lastName = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          title: const Text('Sign up to this app'),
          actions: <Widget>[
            TextButton.icon(
                onPressed: () => widget.toggleView(),
                icon: const Icon(Icons.person),
                label: const Text('Sign in')),
          ]),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
                key: _formkey,
                child: Column(children: <Widget>[
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "First name"),
                    validator: (val)=> val!.isEmpty ? 'Enter first name' : null,
                    onChanged: (val) {
                      setState(() => firstName = val);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Last name"),
                    validator: (val)=> val!.isEmpty ? 'Enter last mail' : null,
                    onChanged: (val) {
                      setState(() => lastName = val);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Email"),
                    validator: (val)=> val!.isEmpty ? 'Enter email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Password"),
                    validator: (val)=> val!.length<6 ? 'Enter password with 6 or more characters' : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                      onPressed: () async {
                        if(_formkey.currentState!.validate()){
                          setState(() => loading = true);

                          //valid form
                          dynamic result = await _auth.registerEmailPassword(firstName, lastName, email, password);
                          if (result == null) {
                            setState(() => {error = 'Please enter a valid email. (Remember @, etc)', loading = false});
                          } // do not need an else. WE have a listener for auth changes so it will automatically change.
                        } else {
                          print("Invalid register-form");
                          //invalid
                        }
                      },
                      child: const Text('Sign up', style: TextStyle(color: Colors.white))),
                  const SizedBox(height:12.0),
                  Text(
                    error,
                    style:  const TextStyle(color:Colors.red, fontSize: 14.0),
                  )
                ]))),
      ),
    );
  }
}
