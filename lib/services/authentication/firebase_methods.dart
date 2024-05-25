import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seller_app/models/sell_item_model.dart';
import 'package:seller_app/models/user_model.dart';

// class to handle all the firebase related stuff
class Authentication {
  // firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // firebase database instance
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  // FIRESTORE METHODS

  // firebase function to create new user
  Future<User?> createUserAuth(
      String name, String email, String password) async {
    try {
      // storing returned user from firebase.createuser function
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log('Error creating new user $e');
      return null;
    }
  }

  // firestore function to store user data to the database
  Future<void> saveUserData(UserModel userModel) async {
    // saving user name and email
    await _fs
        .collection('users')
        .doc(userModel.userUid)
        .set(userModel.toJson());
  }

  Future<UserModel> fetchSingleData(String email) async {
    QuerySnapshot snapshot =
        await _fs.collection('users').where('email', isEqualTo: email).get();
    final userData = snapshot.docs
        .map((e) =>
            UserModel.fromSnapshot(e as DocumentSnapshot<Map<String, dynamic>>))
        .single;
    return userData;
  }

  Future<List<UserModel>> fetchListData() async {
    final snapshot = await _fs.collection('users').get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> saveItemData(SellItemModel sellItemModel) async {
    _fs
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('items_posted')
        .doc();
  }

  // FIREBASE AUTHENTICATION METHODS

  //Google sign in method
  Future<User?> SigninWithGoogle() async {
    try {
      
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? authentication =
          await googleUser?.authentication;

      OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication!.accessToken,
          idToken: authentication.idToken);
      UserCredential? userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        return userCredential.user;
      } else {
        return null;
      }
    } catch (error) {
      log('error at google sign in $error');
    }
  }

  // firebase function to login user
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // returning user for data requirement
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log('error logging in user $e');
      return null;
    }
  }

  // function to logout user
  void logOutUser() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      await googleSignIn.signOut();
      
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      log('error logging out $e');
    }
  }

  Future<bool> forgotPass(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      // show snackbar
      log('error forgotting pass $e');
      return false;
    }
  }
}
