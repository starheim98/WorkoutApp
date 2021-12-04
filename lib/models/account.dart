import 'package:workout_app/models/weight_lifting/weight_workout.dart';

/// Account class for connection to Firebase.
class Account{
  final String uid; //Unique ID of user.

  Account({required this.uid}); //Constructor
}

// Account data class.
class AccountData{
  final String uid; //Unique ID of user.
  final String email; //User's name.
  List<String> friends = []; // List of UIDs

  AccountData({required this.uid, required this.email}); //Constructor

  bool addFriend(String uid){
    bool success = false;
    if(friends.contains(uid)){
      friends.add(uid);
      success = true;
    }
    return success;
  }
}