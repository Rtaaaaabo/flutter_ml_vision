import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  final String uid;
  DataService({this.uid});
  //  collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brew');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strengs': strength,
    });
  }
}
