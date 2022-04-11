// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore
{
  FirebaseFirestore obj= FirebaseFirestore.instance;

  FirebaseFirestore getFirestoreInstance() {
    return obj;
  }

  Future<void> setData(collectionName,docName,data) async {
      return await obj.collection(collectionName)
          .doc(docName)
          .set(data)
          .then((value) => print("Data Added"))
          .catchError((error) => print("Failed to add Data: $error"));
    }
  
  Future<Map<String, dynamic>> getData(collectionName,docName) async {
    Map<String, dynamic> data={};
    await obj.collection(collectionName).doc(docName).get().then((value) {
      if(value.data()!=null)
      {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        print(data);
        return data;
      }
    });
    return data;
  }

  Future<void> updateData(collectionName,docName,data) async {
    return await obj.collection(collectionName)
        .doc(docName)
        .update(data)
        .then((value) => print("Data Added"))
        .catchError((error) => print("Failed to add Data: $error"));
  }
  
  Future<void> deleteData(collectionName,docName) async {
    return obj.collection(collectionName)
      .doc(docName)
      .delete()
      .then((value) => print("User Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
  }

}