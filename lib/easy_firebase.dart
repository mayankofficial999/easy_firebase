library easy_firebase;

import 'package:easy_firebase/auth/authentication.dart';
import 'package:easy_firebase/firestore/firestore_func.dart';
import 'package:easy_firebase/rtdb/realtime_db.dart';
import 'package:easy_firebase/storage/firestore_storage.dart';

/// A class that provides easy access to various Firebase services including
/// authentication, Firestore database operations, Realtime Database operations,
/// and Firebase Storage operations.
class EasyFire {

  /// Returns an instance of [FireStore] which provides methods for interacting
  /// with Firestore database.
  FireStore getFirestoreObject() {
    return FireStore();
  }

  /// Returns an instance of [Authentication] which provides methods for user
  /// authentication processes such as signing in, signing out, and managing user
  /// sessions with different providers (Google, Facebook, etc.).
  Authentication getAuthObject() {
    return Authentication();
  }

  /// Returns an instance of [RTDB] which provides methods for interacting with
  /// Firebase Realtime Database.
  RTDB getRtdbObject() {
    return RTDB();
  }

  /// Returns an instance of [FireStorage] which provides methods for uploading,
  /// downloading, and managing files in Firebase Storage.
  FireStorage getStorageObject() {
    return FireStorage();
  }
}
