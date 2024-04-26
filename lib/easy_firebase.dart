/// Provides easy access to various Firebase services for Dart and Flutter applications.
///
/// This library encapsulates the functionality of Firebase services into
/// easy-to-use classes and methods, simplifying the integration of Firebase
/// features into Dart and Flutter applications. It offers convenient wrappers
/// for authentication, Firestore database operations, Realtime Database operations,
/// and Firebase Storage operations.
///
/// Example usage:
/// ```dart
/// import 'package:easy_firebase/easy_firebase.dart';
///
/// void main() {
///   final easyFire = EasyFire();
///
///   // Authentication example
///   final auth = easyFire.getAuthObject();
///   auth.signInWithEmailAndPassword('email', 'password');
///
///   // Firestore example
///   final firestore = easyFire.getFirestoreObject();
///   firestore.getData('collection/document');
///
///   // Realtime Database example
///   final rtdb = easyFire.getRtdbObject();
///   rtdb.getData('path/to/data');
///
///   // Firebase Storage example
///   final storage = easyFire.getStorageObject();
///   storage.uploadFile('path/to/file', 'destination/path');
/// }
/// ```
///
/// For more information on Firebase services, refer to the official Firebase documentation:
/// https://firebase.google.com/docs
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
