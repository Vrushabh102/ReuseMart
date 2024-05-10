import 'package:flutter/material.dart';

class DisplayHomeScreen extends StatefulWidget {
  const DisplayHomeScreen({super.key});

  @override
  State<DisplayHomeScreen> createState() => _DisplayHomeScreenState();
}

class _DisplayHomeScreenState extends State<DisplayHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}