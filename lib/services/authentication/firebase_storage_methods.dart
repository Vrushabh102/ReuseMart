import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageMethods {
  final _firebaseStorage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> getDownloadURLs(Uint8List image) async {
    try {
      Reference ref = _firebaseStorage
          .ref()
          .child('posted_images')
          .child(_auth.currentUser!.uid)
          .child(userUid());

      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      log('some error ');
      return '';
    }
  }

  // userUid with timestamp
  String userUid() {
    return '${_auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
