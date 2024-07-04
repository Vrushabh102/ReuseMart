import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/core/Providers/user_provider.dart';
import 'package:seller_app/features/auth/controller/auth_controller.dart';
import 'package:seller_app/firebase_options.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/models/user_model.dart';
import 'package:seller_app/riverpod/advertisment_state.dart';
import 'package:seller_app/features/auth/screens/login_screen.dart';
import 'package:seller_app/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/services/firestore_services.dart';
import 'package:seller_app/utils/colors.dart';

// riverpod providers

//for advertisement state management
final advertisementProvider =
    StateNotifierProvider<AdvertisementNotifier, AdvertisementModel>(
  (ref) => AdvertisementNotifier(),
);

// home screen advertisements future state
final futureFeedAdvertisementsProvider =
    FutureProvider<List<AdvertisementModel>>((ref) async {
  final querySnapshot = await FirestoreServices().fetchFeedAdvertisements();
  List<AdvertisementModel> advertisements = querySnapshot.docs
      .map((e) => AdvertisementModel.fromSnapShot(
          e as DocumentSnapshot<Map<String, dynamic>>))
      .toList();
  return advertisements;
});

// user ads future provider
final userAdsProvider = FutureProvider<List<AdvertisementModel>>((ref) async {
  final ads = await FirestoreServices().fetchAllUserAdvertisementDetails();
  return ads;
});


void main() async {
  // initilizing firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'Inter',
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Inter',
        ),

        // to check the FirebaseAuth state of the user
        home: const MyApp(),

        title: "ReuseMart",
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  // fun to fetch user detils and store it to the userProvider
  Future<void> getUserData(WidgetRef ref, User data) async {
    log('get data called');
    // final userModelFromFirebase =
    //     await ref.watch(authControllerProvider).getUserData(data.uid).first;
    // ref.read(userProvider.notifier).setUserDetails(userModelFromFirebase);
    log('Null name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ref.watch(authStateChangeStreamProvider).when(
        data: (data) {
          if (data != null) {
            log('data is not null');
            getUserData(ref, data);
            log('going to homescrreen 2');
            return const HomeScreen();
            // return const HomeScreen();
          } else {
            log('data is null');
            return const LoginScreen();
          }
        },
        error: (error, stackTrace) {
          return Center(
            child: Text('error: $error'),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        },
      ),
    );
  }
}
