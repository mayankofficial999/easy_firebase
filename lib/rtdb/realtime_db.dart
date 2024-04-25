// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';

/// A class for handling basic Realtime Database operations such as retrieving,
/// adding, and deleting data within a Firebase Realtime Database.
class RTDB {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  /// Returns the instance of [FirebaseDatabase] used in this class.
  FirebaseDatabase getRtdbInstance() {
    return database;
  }

  /// Adds or updates data at a specified node path in the database.
  ///
  /// The [nodePath] specifies the path within the database where data should be set.
  /// The [data] can be any type of data supported by Firebase Realtime Database.
  /// Prints "Data Sent" upon successful data submission.
  Future<void> setData(String nodePath, dynamic data) async {
    await database.ref(nodePath).set(data);
  }

  /// Retrieves data from a specified node path in the database.
  ///
  /// The [nodePath] specifies the path within the database from which data is to be fetched.
  /// Returns the data as an [Object] if the path exists and has data; otherwise, returns null.
  Future<Object?> getData(String nodePath) async {
    Object? _val = {};
    await database.ref(nodePath).once().then((event) {
      var data = event.snapshot.value;
      _val = data;
    });
    return _val;
  }

  /// Deletes data at a specified node path in the database.
  ///
  /// The [nodePath] specifies the path within the database where data should be removed.
  /// Prints "Data Deleted" upon successful deletion of data.
  Future<void> removeData(String nodePath) async {
    await database.ref(nodePath).remove();
  }
}
