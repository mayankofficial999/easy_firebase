// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

/// A class for handling basic Firestore operations such as retrieving, adding,
/// updating, and deleting documents within a Firestore collection.
class FireStore {
  final FirebaseFirestore obj = FirebaseFirestore.instance;

  /// Returns the instance of [FirebaseFirestore] used in this class.
  FirebaseFirestore getFirestoreInstance() {
    return obj;
  }

  /// Adds or replaces data in a specified document within a collection.
  ///
  /// The [collectionName] specifies the collection in which to add the document,
  /// and [docName] specifies the document name. The [data] is the map containing
  /// the data to be added. Prints the outcome of the operation.
  Future<void> setData(String collectionName, String docName, Map<String, dynamic> data) async {
    return await obj.collection(collectionName)
        .doc(docName)
        .set(data)
        .then((value) => print("Data Added"))
        .catchError((error) => print("Failed to add Data: $error"));
  }
  
  /// Retrieves data from a specified document within a collection.
  ///
  /// The [collectionName] specifies the collection and [docName] specifies the document
  /// from which data is to be fetched. Returns a map of the data if the document exists.
  Future<Map<String, dynamic>> getData(String collectionName, String docName) async {
    DocumentSnapshot docSnapshot = await obj.collection(collectionName).doc(docName).get();
    if (docSnapshot.data() != null) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      print(data);
      return data;
    }
    return {};
  }

  /// Updates data in a specified document within a collection.
  ///
  /// The [collectionName] specifies the collection and [docName] specifies the document
  /// to be updated. The [data] is the map containing the data to be updated.
  /// Prints the outcome of the operation.
  Future<void> updateData(String collectionName, String docName, Map<String, dynamic> data) async {
    return await obj.collection(collectionName)
        .doc(docName)
        .update(data)
        .then((value) => print("Data Updated"))
        .catchError((error) => print("Failed to update data: $error"));
  }
  
  /// Deletes a specified document from a collection.
  ///
  /// The [collectionName] specifies the collection and [docName] specifies the document
  /// to be deleted. Prints the outcome of the operation.
  Future<void> deleteData(String collectionName, String docName) async {
    return obj.collection(collectionName)
      .doc(docName)
      .delete()
      .then((value) => print("User Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
  }
}
