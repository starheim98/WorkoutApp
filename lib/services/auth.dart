import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('users'); //reference to the users collection.

  //Create user object based on firebase user. BASICALLY filters all the
  //unwanted fields from the regular user to our custom version.
  Account? _userFromFirebaseUser(User user){
    return user != null ? Account(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<Account?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in email&password
  Future signInEmailPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register email&password
  Future registerEmailPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;


      ///// Create collection of users -> create document with the registered users uid + email.
      // Will not override - cause our AUTH uses unique emails.
      await users.doc(email).set({
        "uid" : user!.uid,
        "email" : email,
        "weight_workouts" : [],
        "runs" : [],
      });
      /////

      //writeUserData(user.uid, user.displayName, )
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e){
      print("ERROR SIGNING OUT");
      print(e.toString());
      return null;
    }
  }

}

