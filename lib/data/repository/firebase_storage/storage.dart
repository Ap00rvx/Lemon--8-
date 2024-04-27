
import 'dart:io';

import 'package:brave/data/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageServices{


  final _storage = FirebaseStorage.instance ;
  Future<String?> uploadImageToFirebaseStorage(XFile xFile) async {
    if (xFile == null) {
      return null; // Handle the case where no image is picked
    }

    final FirebaseStorage storage = FirebaseStorage.instance;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
        '_' +
        xFile.name!;
    Reference storageReference = storage.ref().child('images/$fileName');
    UploadTask _uploadTask = storageReference.putFile(File(xFile.path));
    _uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      print('Upload progress: $progress');
    });
    String? downloadUrl;
    await _uploadTask.whenComplete(() async {
      downloadUrl = await storageReference.getDownloadURL();
    });
    return downloadUrl;
  }


  uploadImagetoFirebaseStorageandreturnUrl (File _selectedImage,UserModel userModel,)async{
    try {
      if (_selectedImage != null) {
        String fileName = userModel.uid.toString() ;
        Reference reference =
        _storage.ref().child('uploads/${userModel.uid}.jpg');

        final  uploadTask = reference.putFile(_selectedImage);

        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        print('File uploaded successfully. Download URL: $downloadURL');
        return downloadURL ;
      } else {
        print('No file selected');
        return '' ;
      }
    } catch (error) {
      print('Error uploading file: $error');
    }

  }

  }