library easy_firebase;

import 'package:easy_firebase/auth/authentication.dart';
import 'package:easy_firebase/Firestore/firestore_func.dart';
import 'package:easy_firebase/rtdb/realtime_db.dart';
import 'package:easy_firebase/storage/firestore_storage.dart';


class EasyFire {

  FireStore getFirestoreObject()
  {
    return FireStore();
  }
  Authentication getAuthObject()
  {
    return Authentication();
  }
  RTDB getRtdbObject() {
    return RTDB();
  }
  FireStorage getStorageObject() {
    return FireStorage();
  }
}
