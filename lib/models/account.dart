/// Account class for connection to Firebase.
class Account{
  final String uid; //Unique ID of user.

  Account({required this.uid}); //Constructor
}


// Account data class.
class AccountData{
  final String uid; //Unique ID of user.
  final String name; //User's name.

  AccountData({required this.uid, required this.name}); //Constructor

}