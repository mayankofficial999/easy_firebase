// ignore_for_file: avoid_print

import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FireStorage {
  firebase_storage.FirebaseStorage storage =firebase_storage.FirebaseStorage.instance;

  firebase_storage.FirebaseStorage getFirestoreStorageInstance(){
    return storage;
  }

  Future<firebase_storage.ListResult> listAll({String filePath='/'}) async {
    firebase_storage.ListResult result =await firebase_storage.FirebaseStorage.instance.ref(filePath).listAll();
    return result;
  } 

  Future<firebase_storage.ListResult> listMaxItems({int max=10,String filePath='/'}) async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref(filePath)
        .list(firebase_storage.ListOptions(maxResults: max));

    if (result.nextPageToken != null) {
      //firebase_storage.ListResult additionalResults =
      await firebase_storage
          .FirebaseStorage.instance
          .ref(filePath)
          .list(firebase_storage.ListOptions(
            maxResults: max,
            pageToken: result.nextPageToken,
          ));
    }
    return result;
  }

  Future<String> getDownloadURL(String filePath) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(filePath)
        .getDownloadURL();
    return downloadURL;
    // Within your widgets:
    // Image.network(downloadURL);
  }

  Future<void> uploadFile({String assetPath='/demo.jpg',var metadata,String uploadPath='/demo.jpg'}) async {
    print("Uploading...");    
    File file=await getFileFromAssets(assetPath);
    print(file.path);
    firebase_storage.UploadTask task =firebase_storage.FirebaseStorage.instance
        .ref(uploadPath)
        .putFile(file,metadata);
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        print('Task state: ${snapshot.state}');
        print(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      }, onError: (e) {
        // The final snapshot is also available on the task via `.snapshot`,
        // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
        print(task.snapshot);
        print(e.toString());

        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        }
      }
    );
    try {
      await task;
      print('Upload complete.');
    } on firebase_storage.FirebaseException catch (e) {
      print(e.code);
        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        }
      }
  }

  Future<String> uploadTextData({required String text,String uploadPath='/'}) async {
    List<int> encoded = utf8.encode(text);
    Uint8List data = Uint8List.fromList(encoded);
    firebase_storage.Reference ref =firebase_storage.FirebaseStorage.instance.ref(uploadPath);
    try {
      // Upload raw data.
      await ref.putData(data);
      // Get raw data.
      Uint8List? downloadedData = await ref.getData();
      // prints -> Hello World!
      print(utf8.decode(downloadedData!));
      return utf8.decode(downloadedData);
    } on firebase_storage.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    return "Couldn't process";
  }

  Future<Map<String, String>?> getMetadata(String filePath) async {
    firebase_storage.FullMetadata metadata = await firebase_storage
        .FirebaseStorage.instance
        .ref(filePath)
        .getMetadata();
    print(metadata.customMetadata);
    return metadata.customMetadata;
  }

  Future<File> getFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
  
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  
    return file;
  }

  Future<void> downloadFile({required String firestorePath, String fileName='default.png'}) async {
    if (Platform.isIOS || Platform.isAndroid) {
      bool status = await Permission.storage.isGranted;
      if (!status) await Permission.storage.request();
    }
    Directory appDocDir = await getTemporaryDirectory();
    File downloadToFile = File('${appDocDir.path}/$fileName');
    print(downloadToFile.path);
    print("Downloading...");
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(firestorePath)
          .writeToFile(downloadToFile);
      String path = await FileSaver.instance.saveFile(fileName.split('.')[0], downloadToFile.readAsBytesSync(),fileName.split('.')[1]);
      print("Download path : $path");
      print("Downloaded and Saved to downloads");
    } on firebase_storage.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
  }

}