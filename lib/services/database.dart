// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:workout_app/models/account.dart';
//
// class DatabaseService {
//
//   final String uid;
//   DatabaseService({required this.uid});
//
//   // collection reference
//   final CollectionReference accountDataCollection = FirebaseFirestore.instance.collection('accountdata');
//
//   Future updateUserData(String profile, String trainingSessions) async{
//     return await accountDataCollection.doc(uid).set({
//       'Profile' : profile,
//       'TrainingSession' : trainingSessions,
//     });
//   }
//
//   //userdata list from snapshot.
//   List<UserData> _userDataListFromSnapshot(QuerySnapshot snapshot){
//     return snapshot.docs.map((doc) {
//       return AccountData(
//         profile: doc.get('Profile') ?? '',
//         trainingSessions: doc.get('TrainingSession') ?? '',
//       );
//     }).toList();
//   }
//
//   Stream<List<UserData>> get userdata {
//     return accountDataCollection.snapshots().map(_userDataListFromSnapshot);
//   }
//
//   CustomUserData _customUserDataFromSnapshot(DocumentSnapshot snapshot){
//     return CustomUserData(
//         uid: uid,
//         profile: snapshot['Profile'],
//         trainingSessions: snapshot['TrainingSession']
//     );
//   }
//
//   // get user document stream
//   Stream<CustomUserData> get customuserdata {
//     return accountDataCollection.doc(uid).snapshots()
//         .map(_customUserDataFromSnapshot);
//   }
// }