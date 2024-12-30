import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final _firebaseStorage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> getDownloadURLs(Uint8List image, String itemId, int uniqueIdentifier) async {
    try {
      Reference ref = _firebaseStorage.ref().child('posted_images').child(_auth.currentUser!.uid).child(itemId).child(uniqueIdentifier.toString());
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  // fun to generete userUid with timestamp - user_timestamp
  String userUid() {
    return '${_auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
