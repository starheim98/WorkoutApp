import 'package:flutter/material.dart';
import 'package:workout_app/services/auth.dart';
import 'package:workout_app/shared/constants.dart';

class Login extends StatefulWidget {

  final Function toggleView;
  Login({required this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold( //if loading is true, show loading. Else show the scaffold.
      backgroundColor: backgroundColor,
      appBar: AppBar(
          elevation:0.0,
          title: const Text('Sign in to this app'),
          actions: <Widget>[
            TextButton.icon(
                onPressed: () =>  widget.toggleView(),
                icon: const Icon(Icons.person, color: Colors.white,),
                label: const Text('Register', style: TextStyle(color: Colors.white),))
          ]
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: _formkey,
              child: Column(
                  children: <Widget>[
                    const SizedBox(height:20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: "Email"),
                      validator: (val)=> val!.isEmpty ? 'Enter email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height:20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: "Password"),
                      validator: (val)=> val!.length<6 ? 'Enter password with 6 or more characters' : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height:20.0),
                    ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff0068C8))),
                        onPressed: () async {
                          if(_formkey.currentState!.validate()){
                            //valid form
                            dynamic result = await _auth.signInEmailPassword(email, password);
                            if (result == null) {
                              setState(() => {error = 'Invalid email or password'});
                            } // do not need an else. WE have a listener for auth changes so it will automatically change.
                          } else {
                            print("Invalid register-form");
                            //invalid
                          }
                        },
                        child: const Text('Sign in',style: TextStyle(color: Colors.white))),
                    const SizedBox(height:12.0),
                    Text(
                      error,
                      style:  const TextStyle(color:Colors.red, fontSize: 14.0),
                    )
                  ]
              )
          )
      ),
    );
  }
}