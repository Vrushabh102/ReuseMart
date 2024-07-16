import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seller_app/core/Providers/firebase_providers.dart';
import 'package:seller_app/core/failure.dart';
import 'package:seller_app/core/type_defs.dart';
import 'package:seller_app/models/user_model.dart';

// auth repository provider
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firebaseFirestoreProvider),
  ),
);

// class to handle all the firebase related stuff
class AuthRepository {
  // firebase authentication instance
  // private variable not initialized, initialized in constructor
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  CollectionReference get _users => _firestore.collection('users');

  Stream<User?> get authStateChange {
    log('auth state changed');
    return _auth.authStateChanges();
  }

  // FIRESTORE METHODS

  // FIREBASE AUTHENTICATION METHODS

  //Google sign in method

  FutureEither<UserModel?> signInWithGoogle() async {
    try {
      log('inside auth repository');
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Check if there's an existing Google sign-in
      GoogleSignInAccount? googleUser = googleSignIn.currentUser;

      googleUser ??= await googleSignIn.signIn();

      if (googleUser == null) {
        return left(Failure('Google sign-in was aborted'));
      }

      final GoogleSignInAuthentication authentication = await googleUser.authentication;

      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        log('user at auth repo is new');
        userModel = UserModel(
          likedAds: const [],
          photoUrl: userCredential.user!.photoURL,
          gender: 'Male',
          fullName: userCredential.user!.displayName,
          email: userCredential.user!.email ?? 'No email',
          userUid: userCredential.user!.uid,
        );
        // save user data to firebase
        await saveUserDataToFirebase(userModel.userUid, userModel);
        return right(userModel);
      } else {
        // user is old, so user must be having data on the database
        userModel = await getUserData(userCredential.user!.uid).first;
        // userModel = await getUserData(userCredential.user!.uid);
        return right(userModel);
      }
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (error) {
      log('error at google sign in $error');
      return left(Failure(error.toString()));
    }
  }

  Future<void> saveUserDataToFirebase(String userUid, UserModel userModel) async {
    await _users.doc(userUid).set(userModel.toMap());
  }

  // if the user is old, user will have data on data base, so
  // fun to get userdata to store in userModel provider
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromSnapshot(event as DocumentSnapshot<Map<String, dynamic>>));
  }

  // firebase function to create new user
  FutureEither<UserModel> createUserAuth(String name, String email, String gender, String password) async {
    try {
      log('now starting create user function in auth repo');
      // storing returned user from firebase.createuser function
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // save user data to the user provider
      UserModel userModel = UserModel(
        likedAds: const [],
        photoUrl: userCredential.user!.photoURL,
        gender: gender,
        fullName: name,
        email: email,
        userUid: userCredential.user!.uid,
      );

      // adding users data to the firebase
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'email-already-in-use') {
        log('firebase error');
        return left(Failure('The email address is already in use by another account.'));
      }
      return left(Failure(e.code));
    } catch (e) {
      log('Error creating new user $e');
      return left(Failure(e.toString()));
    }
  }

  // firebase function to login user with email and password
  FutureEither<UserModel> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      final userDoc = await _users.doc(userCredential.user!.uid).get() as DocumentSnapshot<Map<String, dynamic>>;
      UserModel model = UserModel.fromSnapshot(userDoc);

      log(userCredential.user!.email ?? 'No email');
      // save user data to the user provider
      return right(model);
    } on FirebaseAuthException catch (e) {
      log('error logging in user ${e.message}');
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid forgotPass(String email) async {
    try {
      final forgotPass = await _auth.sendPasswordResetEmail(email: email);

      return right(forgotPass);
    } on FirebaseAuthException catch (e) {
      // show snackbar
      log('error forgotting pass $e');
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // function to logout user
  FutureVoid logOutUser() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      await googleSignIn.signOut();

      final signOut = await _auth.signOut();

      return right(signOut);
    } on FirebaseAuthException catch (e) {
      log('error logging out $e');
      return left(Failure(e.code.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
