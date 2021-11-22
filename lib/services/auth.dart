import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_app/models/account.dart';
import 'package:workout_app/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

      // create a new document for the user with the uid.
      await DatabaseService(uid: user!.uid).updateUserData(email);
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