// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert' show utf8;
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

/// A class for handling Firebase Storage operations including file upload, download,
/// and metadata retrieval, as well as managing Firebase Storage instances.
class FireStorage {
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  /// Returns the instance of [firebase_storage.FirebaseStorage] used in this class.
  firebase_storage.FirebaseStorage getFirestoreStorageInstance() {
    return storage;
  }

  /// Lists all items under a specified [filePath] in Firebase Storage.
  Future<firebase_storage.ListResult> listAll({String filePath = '/'}) async {
    return await storage.ref(filePath).listAll();
  }

  /// Lists items with pagination under a specified [filePath], up to [max] items.
  Future<firebase_storage.ListResult> listMaxItems({int max = 10, String filePath = '/'}) async {
    firebase_storage.ListResult result = await storage
        .ref(filePath)
        .list(firebase_storage.ListOptions(maxResults: max));
    return result;
  }

  /// Retrieves a download URL for a file located at [filePath] in Firebase Storage.
  Future<String> getDownloadURL(String filePath) async {
    String downloadURL = await storage.ref(filePath).getDownloadURL();
    return downloadURL;
  }

  /// Uploads a file from storage to Firebase Storage or optionally from local assets with [assetPath] to Firebase Storage at [uploadPath].
  /// Optional metadata can be provided with [metadata].
  Future<void> uploadFile({String assetPath = '', var metadata, String uploadPath = '/'}) async {
    File file;
    if(assetPath.isNotEmpty) {
      file = await getFileFromAssets(assetPath);
      await uploadTask(uploadPath, file, metadata: metadata);
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        file = File(result.files.single.path!);
        await uploadTask(uploadPath + '/' + result.files[0].name, file, metadata: metadata);
      } else {
        // User canceled the picker
      }
    }
  }

  Future<void> uploadTask(String uploadPath, File file, {var metadata}) async {
    firebase_storage.UploadTask task = storage.ref(uploadPath).putFile(file, metadata);
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      }, 
      onError: (e) {
        print(e);
        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        }
      }
    );
    try {
      await task;
    } catch (e) {
      print(e);
    }
  }

  /// Uploads text data [text] to Firebase Storage at [uploadPath] and retrieves it back.
  Future<String> uploadTextData({required String text, String uploadPath = '/'}) async {
    Uint8List data = Uint8List.fromList(utf8.encode(text));
    firebase_storage.Reference ref = storage.ref(uploadPath);
    await ref.putData(data);
    Uint8List? downloadedData = await ref.getData();
    return utf8.decode(downloadedData!);
  }

  /// Retrieves custom metadata for a file located at [filePath] in Firebase Storage.
  Future<Map<String, String>?> getMetadata(String filePath) async {
    firebase_storage.FullMetadata metadata = await storage.ref(filePath).getMetadata();
    return metadata.customMetadata;
  }

  /// Helper method to get a file from local assets.
  Future<File> getFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  /// Downloads a file from Firebase Storage at [firestorePath].
  /// The file can be saved under the optional name [fileName].
  Future<void> downloadFile({required String firestorePath, String fileName = ''}) async {
    if (Platform.isIOS || Platform.isAndroid) {
      bool status = await Permission.storage.isGranted;
      if (!status) {
        await Permission.storage.request();
      }
    }
    Directory appDocDir = await getTemporaryDirectory();
    File downloadToFile = File('${appDocDir.path}/${basename(firestorePath)}');
    try {
      await storage.ref(firestorePath).writeToFile(downloadToFile);
      await FilePicker.platform.saveFile(
        fileName: fileName.isNotEmpty ? fileName : basename(downloadToFile.path), 
        bytes: downloadToFile.readAsBytesSync()
      );
    } catch (e) {
      print(e);
    }
  }
}
