import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/firebase_options.dart';
import 'package:seller_app/models/advertisement_model.dart';
import 'package:seller_app/riverpod_state_management/advertisment_state.dart';
import 'package:seller_app/screens/auth/login_screen.dart';
import 'package:seller_app/screens/mobile_screen.dart';
import 'package:seller_app/responsive/responsive_layout.dart';
import 'package:seller_app/screens/web_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// riverpod providers

//for advertisement state management
final advertisementProvider =
    StateNotifierProvider<AdvertisementNotifier, AdvertisementModel>(
        (ref) => AdvertisementNotifier());

void main() async {
  // initilizing firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(
    child: MaterialApp(
      theme: ThemeData(brightness: Brightness.light, fontFamily: 'Inter'),
      darkTheme: ThemeData(brightness: Brightness.dark, fontFamily: 'Inter'),

      // to check the FirebaseAuth state of the user
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if the FirebaseAuth is in loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.green),
            );
          }
          // if the FirebaseAuth state is active
          else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const MyApp();
            } else {
              return const LoginScreen();
            }
          }

          return const LoginScreen();
        },
      ),

      title: "ReuseMart",
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScreen: MobileScreen(),
      webScreen: WebScreen(),
    );
  }
}
