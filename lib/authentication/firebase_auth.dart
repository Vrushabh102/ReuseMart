import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

// class to handle all the firebase authentication related stuff
class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      return false;
    }
  }
}
