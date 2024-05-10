import 'package:flutter/material.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('My Ads'),
      ),
    );
  }
}