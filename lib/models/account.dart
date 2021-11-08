/// Account class for connection to Firebase.
class Account{
  final String uid; //Unique ID of user.

  Account({required this.uid}); //Constructor
}

// Account data class.
class AccountData{
  final String uid; //Unique ID of user.
  final String name; //User's name.
  List<String>? friends;

  AccountData({required this.uid, required this.name}); //Constructor

  bool addFriend(String uid){
    bool success = false;
    if(!friends!.contains(uid)){
      friends!.add(uid);
      success = true;
    }
    return success;
  }

}