import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/firebase_options.dart';
import 'package:seller_app/responsive/mobile_screen.dart';
import 'package:seller_app/responsive/responsive_layout.dart';
import 'package:seller_app/responsive/web_screen.dart';

void main() async {
  // initilizing firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: const MyApp(),
    title: "ReuseMart",
    debugShowCheckedModeBanner: false,
    darkTheme: ThemeData.dark()
        .copyWith(scaffoldBackgroundColor: const Color.fromARGB(0, 0, 0, 0)),
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
