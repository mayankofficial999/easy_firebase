// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';

class RTDB {
  FirebaseDatabase database = FirebaseDatabase.instance;

  FirebaseDatabase getRtdbInstance(){
    return database;
  }

  Future<void> setData(String nodePath,var data) async {
    await database.ref(nodePath).set(data);
    print("Data Sent");
  }

  Future<Map<String, dynamic>> getData(String nodePath) async {
    Map<String, dynamic> _val={};
    await database.ref(nodePath).once().then((event) {
      var data=event.snapshot.value;
      _val = Map<String, dynamic>.from(data as Map);
      print(_val);
    });
    return _val;
  }

  Future<void> removeData(String nodePath) async {
    await database.ref(nodePath).remove();
    print('Data Deleted');
  }

}