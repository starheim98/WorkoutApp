import 'package:workout_app/models/weight_lifting/weight_workout.dart';

/// Account class for connection to Firebase.
class Account{
  final String uid; //Unique ID of user.

  Account({required this.uid}); //Constructor
}

// Account data class.
class AccountData{
  String _firstName;
  String _lastName;
  final String _uid; //Unique ID of user.
  final String _email; //User's name.
  List<String> _friends = [];

  AccountData(this._firstName, this._lastName, this._uid, this._email,
      this._friends); // List of UIDs

  factory AccountData.fromJson(Map<String, dynamic> json) {
    String firstName = json['firstName'];
    String lastName = json['lastName'];
    String uid = json['uid'];
    String email = json['email'];
    List<String> friends = [];
    for (var uid in json['friends']) {
      friends.add(uid);
    }
    return AccountData(firstName, lastName, uid, email, friends);
  }

  String getName() {
    return _firstName + " " + _lastName;
  }

  String get firstName => _firstName;

  bool isFriendWith(String uid) {
    return _friends.contains(uid);
  }

  bool addFriend(String uid){
    if(!_friends.contains(uid)){
      _friends.add(uid);
       return true;
    } else {
      return false;
    }
  }

  bool unfollowFriend(String uid) {
    if(_friends.contains(uid)) {
      _friends.remove(uid);
      return true;
    } else {
      return false;
    }
  }

  String get lastName => _lastName;

  String get uid => _uid;

  String get email => _email;

  List<String> get friends => _friends;
}