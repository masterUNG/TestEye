import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:joelfindtechnician/models/user_model_old.dart';

class FindUserByUid {
  final String uid;
  FindUserByUid({
    required this.uid,
  });

 
 
 
 
 
 
 
 
 

  Future<UserModelOld> getUserModel() async {
    UserModelOld? userModelOld;

    Firebase.initializeApp();
    var result = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .get();

    for (var item in result.docs) {
      userModelOld = UserModelOld.fromMap(item.data());
    }

    return userModelOld!;
  }
}
