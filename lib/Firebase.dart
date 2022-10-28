import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'dart:io';

import 'constants.dart';

/** FirebaseService
 * handles all firebase uploads
 * **/
class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  uploadData(BuildContext context, File imageFile, double latitude,
      double longitude, String timestamp) async {

    await firestore.collection(kData).doc(timestamp).set({
      kLatitude: latitude, kLongitude: longitude
    });
    await firestore.collection(kData).doc(timestamp).update({
      kTimestamp: timestamp
    });
    await firestore.collection(kData).doc(timestamp).update({
      kUserId: auth.currentUser!.uid
    });
    String fileName = imageFile.path;
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    await uploadTask.then((res) {
      res.ref.getDownloadURL().then((value) async {
        await firestore.collection(kData).doc(timestamp).update(
            {kImage: value});
      });
    });
    return true;
  }
//   Future uploadImageToFirebase(BuildContext context,File imageFile,String timestamp)
//   async {
//     String fileName = imageFile.path;
//     Reference firebaseStorageRef =
//     FirebaseStorage.instance.ref().child('uploads/$fileName');
//     UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
//     uploadTask.then((res) {
//       res.ref.getDownloadURL().then((value) async{
//           await firestore.collection(kData).doc(timestamp).update({kImage: value});
//       });
//     });
//     return true;
//
//   }
// }
}